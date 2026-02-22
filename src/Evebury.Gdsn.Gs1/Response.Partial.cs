using Evebury.Gdsn.Gs1.Message;
using Evebury.Gdsn.Gs1.Xml.Schema;
using Evebury.Gdsn.Gs1.Xsl;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Resources;
using System.Text;
using System.Text.Json;
using System.Xml;

namespace Evebury.Gdsn.Gs1
{
    public partial class Response
    {
        private const string VALIDATION_RESPONSE = "validation_response";
        

        /// <summary>
        /// If true the reponse is a validation response rendered before delivery to Gs1
        /// otherwise the response id will be set to Gs1 response message id indicating this reponse was delivered to Gs1 
        /// </summary>
        public bool IsValidationResponse => Id == VALIDATION_RESPONSE;

        /// <summary>
        /// ctor
        /// </summary>
        public Response() { }

        /// <summary>
        /// Converts this reponse to a json string
        /// </summary>
        /// <returns cref="string"></returns>
        public string ToJson()
        {
            return JsonSerializer.Serialize(this);
        }

        /// <summary>
        /// Converts this reponse to a xml document
        /// </summary>
        /// <returns cref="XmlDocument"></returns>
        public XmlDocument ToXmlDocument()
        {
            XmlDocument xd = new();
            using (MemoryStream stream = new())
            {
                new System.Xml.Serialization.XmlSerializer(GetType()).Serialize(stream, this);
                stream.Position = 0;
                xd.Load(stream);
            }
            return xd;
        }

        /// <summary>
        /// Returns this reponse as a div for display purposes
        /// </summary>
        /// <param name="cultureInfo">Optional cultureinfo for setting datetime and labels</param>
        /// <param name="dateTimeFormat">Optional datetime format e.g. "dd-MM-yyyy"</param>
        /// <returns cref="string"></returns>
        public string ToXhtml(CultureInfo cultureInfo = null, string dateTimeFormat = null)
        {
            cultureInfo = cultureInfo ?? CultureInfo.InvariantCulture;
            ResourceManager resource = Resource.Auxiliary.ResourceManager;
            StringBuilder sb = new();
            sb.Append("<div class=\"gs1_reponse\">");
            sb.Append("<div class=\"gs1_response_header\">");
            sb.Append("<div class=\"gs1_response_label\">");
            sb.Append(resource.GetString(nameof(Response), cultureInfo));
            sb.Append("</div>");
            sb.Append("<div class=\"gs1_response_id\">");
            sb.Append(Id);
            sb.Append("</div>");
            sb.Append("<div class=\"gs1_response_time\">");
            sb.Append(TimeStamp.ToString(dateTimeFormat, cultureInfo));
            sb.Append("</div>");
            string status = Status.ToString().ToLowerInvariant();
            sb.Append($"<div class=\"gs1_response_status {status}\">");
            sb.Append("<span class=\"gs1_response_status_label\">");
            sb.Append(resource.GetString(status, cultureInfo));
            sb.Append("</span>");
            sb.Append("</div>");
            sb.Append("</div>");
            if (Transactions != null)
            {
                foreach (Transaction transaction in Transactions)
                {
                    sb.Append("<div class=\"gs1_transaction\">");

                    sb.Append("<div class=\"gs1_transaction_header\">");

                    sb.Append("<div class=\"gs1_transaction_label\">");
                    sb.Append(resource.GetString(nameof(Transaction), cultureInfo));
                    sb.Append("</div>");
                    sb.Append("<div class=\"gs1_transaction_id\">");
                    sb.Append(transaction.Id);
                    sb.Append("</div>");
                    status = transaction.Status.ToString().ToLowerInvariant();
                    sb.Append($"<div class=\"gs1_transaction_status {status}\">");
                    sb.Append("<span class=\"gs1_transaction_status_label\">");
                    sb.Append(resource.GetString(status, cultureInfo));
                    sb.Append("</span>");
                    sb.Append("</div>");

                    sb.Append("</div>");


                    if (transaction.Events != null)
                    {
                        foreach (Event @event in transaction.Events)
                        {
                            sb.Append("<div class=\"gs1_event\">");

                            sb.Append("<div class=\"gs1_event_header\">");

                            sb.Append("<div class=\"gs1_event_id\">");
                            sb.Append(@event.Id);
                            sb.Append("</div>");
                            sb.Append("<div class=\"gs1_event_message\">");
                            sb.Append(@event.Message);
                            sb.Append("</div>");
                            string level = @event.Level.ToString().ToLowerInvariant();
                            sb.Append($"<div class=\"gs1_event_level {level}\">");
                            sb.Append("<span class=\"gs1_event_level_label\">");
                            sb.Append(resource.GetString(level, cultureInfo));
                            sb.Append("</span>");
                            sb.Append("</div>");

                            sb.Append("</div>");

                            if (@event.Data != null)
                            {
                                sb.Append("<div class=\"gs1_event_data\">");
                                foreach (EventData data in @event.Data)
                                {
                                    sb.Append("<div class=\"gs1_event_data_row\">");
                                    sb.Append("<div class=\"gs1_event_data_key\">");
                                    if (data.Label != null) sb.Append(data.Label);
                                    else sb.Append(data.Key);
                                    sb.Append("</div>");
                                    sb.Append("<div class=\"gs1_event_data_value\">");
                                    sb.Append(data.Value);
                                    sb.Append("</div>");
                                    sb.Append("</div>");
                                }
                                sb.Append("</div>");
                            }

                            sb.Append("</div>");
                        }
                    }

                    sb.Append("</div>");
                }
            }
            sb.Append("</div>");
            return sb.ToString();
        }

        #region summary
        internal void Summarize(CultureInfo cultureInfo, int version)
        {
            if (version == 0) return;

            if (Transactions != null)
            {
                foreach (Transaction transaction in Transactions)
                {
                    Summarize(transaction, version, cultureInfo);
                }
            }
        }

        private static void Summarize(Transaction transaction, int version, CultureInfo cultureInfo)
        {
            if (transaction.Events != null)
            {
                foreach (Event @event in transaction.Events)
                {
                    Summarize(@event, version, cultureInfo);
                }
            }
        }

        private static void Summarize(Event @event, int version, CultureInfo cultureInfo)
        {
            if (@event != null)
            {
                if (cultureInfo.LCID != CultureInfo.InvariantCulture.LCID)
                {
                    switch (@event.Id)
                    {
                        case EventId.SCHEMA: break; //non translatable messages
                        case EventId.COMPARE_EQUAL:
                            {
                                string message = Resource.Auxiliary.ResourceManager.GetString(@event.Id, cultureInfo);
                                if (message != null)
                                {
                                    @event.Message = message;
                                }
                                break;
                            }
                        default:
                            {
                                switch (version)
                                {
                                    case 3:
                                        {
                                            string message = R3.Resource.Message.ResourceManager.GetString(@event.Id, cultureInfo);
                                            if (message != null)
                                            {
                                                @event.Message = message;
                                            }
                                            break;
                                        }
                                }
                                break;
                            }
                    }

                }

                if (@event.Data != null)
                {
                    Dictionary<string, HashSet<string>> data = [];
                    List<EventData> list = [];
                    list.AddRange(@event.Data);
                    foreach (EventData eventData in list)
                    {
                        string key = eventData.Key;
                        switch (key)
                        {
                            case EventDataKey.DESCRIPTOR: break;
                            case EventDataKey.GTIN:
                                {
                                    EventData descriptor = list.Find(e => e.Key == EventDataKey.DESCRIPTOR && e.Sequence == eventData.Sequence);
                                    AddEventData(data, EventDataKey.CATALOGUE_ITEM, $"{descriptor.Value} ({eventData.Value})");
                                    break;
                                }
                            case EventDataKey.INFORMATION_PROVIDER:
                            case EventDataKey.TRADE_PARTNER:
                                {
                                    AddEventData(data, key, $"{eventData.Label} ({eventData.Value})");
                                    break;
                                }
                            case EventDataKey.MARKET:
                                {
                                    string label = eventData.Value;
                                    switch (version)
                                    {
                                        case 3:
                                            {
                                                string code = R3.Resource.Market.ResourceManager.GetString(eventData.Value);
                                                if (code != null) label = code;
                                                break;
                                            }
                                    }
                                    AddEventData(data, key, $"{label} ({eventData.Value})");
                                    break;
                                }
                            case EventDataKey.BRICK:
                                {
                                    string label = eventData.Value;
                                    switch (version)
                                    {
                                        case 3:
                                            {
                                                string code = R3.Resource.Brick.ResourceManager.GetString(eventData.Value);
                                                if (code != null) label = code;
                                                break;
                                            }
                                    }
                                    AddEventData(data, key, $"{label} ({eventData.Value})");
                                    break;
                                }
                            default:
                                {
                                    AddEventData(data, key, eventData.Value);
                                    break;
                                }
                        }
                    }

                    list.Clear();
                    foreach (string key in data.Keys)
                    {
                        string label = Resource.Auxiliary.ResourceManager.GetString(key, cultureInfo);
                        list.Add(new EventData() { Key = key, Value = string.Join(", ", data[key]), Label = label });
                    }
                    @event.Data = [.. list];
                }
            }
        }

        private static void AddEventData(Dictionary<string, HashSet<string>> data, string key, string value)
        {
            if (data.TryGetValue(key, out HashSet<string> source))
            {
                source.Add(value);
            }
            else
            {
                source = [];
                source.Add(value);
                data.Add(key, source);
            }
        }
        #endregion


        #region internal

        internal static Response GetResponse()
        {
            return new Response()
            {
                Id = VALIDATION_RESPONSE,
                TimeStamp = DateTime.UtcNow,
                Status = StatusType.OK,
            };
        }

        internal static Transaction GetTransaction(string transactionId, List<Event> events = null)
        {
            Transaction transaction = new()
            {
                Id = transactionId,
                Status = TransactionStatusType.NO_ACTION,
            };

            if (events != null && events.Count > 0)
            {
                if (events.Exists(e => e.Level == EventLevel.ERROR)) transaction.Status = TransactionStatusType.REJECTED;
                transaction.Events = [.. events];
            }

            return transaction;
        }

        internal static Event GetEvent(string eventId, string message, EventLevel level, List<EventData> data = null)
        {
            Event @event = new()
            {
                Id = eventId,
                Message = message,
                Level = level,
            };
            if (data != null && data.Count > 0)
            {
                @event.Data = [.. data];
            }
            return @event;
        }

        internal static Response GetResponse(XmlSchemaValidatorResult result)
        {
            Response response = GetResponse();
            if (!result.IsValid)
            {
                response.Status = StatusType.ERROR;

                List<Event> events = [];
                foreach (XmlSchemaValidatorMessage message in result.Messages)
                {
                    List<EventData> data = [];
                    if (message.XPath != null)
                    {
                        data.Add(new EventData() { Key = EventDataKey.XPATH, Value = message.XPath });
                    }
                    EventLevel level = message.Severity == XmlSchemaValidatorSeverity.Error ? EventLevel.ERROR : EventLevel.WARN;
                    events.Add(GetEvent(EventId.SCHEMA, message.Message, level, data));

                }
                Transaction transaction = GetTransaction(VALIDATION_RESPONSE, events);
                response.Transactions = [transaction];
            }
            return response;
        }

        internal static Response GetResponse(bool compareResult)
        {
            Response response = GetResponse();

            if (compareResult)
            {
                List<Event> events = [];
                events.Add(GetEvent(EventId.COMPARE_EQUAL, Resource.Auxiliary.ResourceManager.GetString(EventId.COMPARE_EQUAL, CultureInfo.InvariantCulture), EventLevel.INFO));
                Transaction transaction = GetTransaction(VALIDATION_RESPONSE, events);
                response.Transactions = [transaction];
            }
            else
            {
                response.Status = StatusType.ERROR;
            }
            return response;
        }
        #endregion
    }
}
