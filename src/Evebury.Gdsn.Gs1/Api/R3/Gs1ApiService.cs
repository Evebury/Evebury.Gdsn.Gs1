using Evebury.Gdsn.Gs1.Message;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;
using System.Xml;

namespace Evebury.Gdsn.Gs1.Api.R3
{
    /// <summary>
    /// Handles validation and publication to Gs1
    /// </summary>
    public class Gs1ApiService
    {
        private readonly Gs1Validator _validator;
        private readonly Gs1ApiCredentials _credentials;

        private const string API_RESPONSE = "gs1_api_response";

        /// <summary>
        /// ctor
        /// </summary>
        /// <param name="credentials">the gs1 api credentials</param>
        public Gs1ApiService(Gs1ApiCredentials credentials)
        {
            _validator = new Gs1Validator();
            _credentials = credentials;
        }

        /// <summary>
        /// TODO!!! Highly experimental
        /// </summary>
        /// <param name="message"></param>
        /// <param name="previous"></param>
        /// <param name="cultureInfo"></param>
        /// <returns></returns>
        /// <exception cref="MessageException"></exception>
        public async Task<Response> Publish(XmlDocument message, XmlDocument previous = null, CultureInfo cultureInfo = null)
        {
            ArgumentNullException.ThrowIfNull(message);
            cultureInfo ??= CultureInfo.InvariantCulture;
            MessageKey key = MessageKey.GetKey(message);
            if (key == MessageKey.CatalogueItemNotification3)
            {
                Response response = await _validator.Validate(key, message, previous, cultureInfo);
                if (response.Status == StatusType.ERROR) return response;
                return await Publish(message);
            }
            throw new MessageException(key);
        }

        private async Task<Response> Publish(XmlDocument message)
        {

            using (HttpClient client = new())
            {
                client.BaseAddress = new Uri(_credentials.BaseUri);
                client.DefaultRequestHeaders.Add("Api-Key", _credentials.ApiKey);

                Response response = await Publish(client, message);
                if (response.Status == StatusType.ERROR) return response;

                return await GetResponse(client, response.Id);
            }
        }

        private static async Task<Response> Publish(HttpClient client, XmlDocument message)
        {
            Response response = Response.GetResponse();
            response.Id = API_RESPONSE;

            string base64;
            using (MemoryStream stream = new())
            {
                message.Save(stream);
                base64 = Convert.ToBase64String(stream.ToArray());
            }

            HttpRequestMessage request = new(HttpMethod.Post, "GdsnMessages/Inbound");
            request.Headers.Add("Content-Type", "text/xml");
            request.Headers.Add("Accept", "text/xml");
            request.Content = new StringContent(base64);

            HttpResponseMessage responseMessage = await client.SendAsync(request);

            if (responseMessage.StatusCode != System.Net.HttpStatusCode.OK)
            {
                response.Status = StatusType.ERROR;
                List<Event> events = [];
                events.Add(new Event() { Id = API_RESPONSE, Message = $"Unexpected HttpStatusCode {responseMessage.StatusCode} received from Api on posting the message.", Level = EventLevel.ERROR });
                Transaction transaction = Response.GetTransaction(API_RESPONSE, events);
                response.Transactions = [transaction];
                return response;
            }

            string json = await responseMessage.Content.ReadAsStringAsync();
            Json.GdsnMessagesInboundResponse jsonResponse = JsonSerializer.Deserialize<Json.GdsnMessagesInboundResponse>(json);

            response = Response.GetResponse();
            response.Id = jsonResponse.RequestIdentifier;
            return response;
        }

        private static async Task<Response> GetResponse(HttpClient client, string identifier)
        {
            Response response = Response.GetResponse();
            response.Id = API_RESPONSE;


            HttpRequestMessage request = new(HttpMethod.Post, "RequestStatus/Get");
            request.Headers.Add("Content-Type", "application/json");
            request.Headers.Add("Accept", "application/json");
            request.Content = new StringContent($"{{\"RequestIdentifier\": \"{identifier}\"}}");

            Json.RequestStatusGetResponse jsonResponse = null;
            int transient = 30; //retry for 30 seconds
            bool isAwaiting = true;
            while (transient > 0 && isAwaiting)
            {
                //wait a second to give the api some head room
                await Task.Delay(1000);
                HttpResponseMessage responseMessage = await client.SendAsync(request);
                switch (responseMessage.StatusCode)
                {
                    case System.Net.HttpStatusCode.OK:
                        {
                            string json = await responseMessage.Content.ReadAsStringAsync();
                            jsonResponse = JsonSerializer.Deserialize<Json.RequestStatusGetResponse>(json);
                            Json.Status status = jsonResponse.GetStatus();
                            switch (status)
                            {
                                case Api.R3.Json.Status.Cancelled:
                                case Api.R3.Json.Status.Failed:
                                case Api.R3.Json.Status.NotFound: 
                                    {
                                        jsonResponse = null;
                                        isAwaiting = false;
                                        break;
                                    }
                                case Api.R3.Json.Status.Done:
                                    {
                                        isAwaiting = false;
                                        break;
                                    }
                                case Api.R3.Json.Status.Paused:
                                case Api.R3.Json.Status.Waiting:
                                case Api.R3.Json.Status.Running:
                                    {
                                        transient--;
                                        break;
                                    }
                            }
                            break;
                        }
                    case System.Net.HttpStatusCode.NotFound:
                        {
                            transient--;
                            break;
                        }
                    default:
                        {
                            response.Status = StatusType.ERROR;
                            List<Event> events = [];
                            events.Add(new Event() { Id = API_RESPONSE, Message = $"Unexpected HttpStatusCode {responseMessage.StatusCode} received from Api on getting the status.", Level = EventLevel.ERROR });
                            Transaction transaction = Response.GetTransaction(API_RESPONSE, events);
                            response.Transactions = [transaction];
                            return response;
                        }
                }
            }

            //https://uat-webapi-datasource.gs1.nl/helpPages/catalogueItemApi/index#!/RequestStatus/RequestStatus_Get
            if (jsonResponse == null || jsonResponse.Gs1ResponseMessage == null || jsonResponse.Gs1ResponseMessage.GS1Response == null)
            {
                response.Status = StatusType.ERROR;
                List<Event> events = [];
                events.Add(new Event() { Id = API_RESPONSE, Message = $"Failed to get response from Api after retries.", Level = EventLevel.ERROR });
                Transaction transaction = Response.GetTransaction(API_RESPONSE, events);
                response.Transactions = [transaction];
                return response;
            }

            //Get from json to reponse this is FOOBAR no option to receive xml
            return jsonResponse.ToResponse();

        }
    }
}
