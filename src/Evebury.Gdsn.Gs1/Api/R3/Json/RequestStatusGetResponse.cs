using System;
using System.Collections.Generic;

namespace Evebury.Gdsn.Gs1.Api.R3.Json
{
    internal enum Status
    {
        NotFound, Waiting, Running, Paused, Cancelled, Failed, Done
    }

    internal class RequestStatusGetResponse
    {
        /// <summary>
        ///  ['NotFound', 'Waiting', 'Running', 'Paused', 'Cancelled', 'Failed', 'Done'],
        /// </summary>
        public string Status { get; set; }
        public Gs1ResponseMessage Gs1ResponseMessage { get; set; }


        public Status GetStatus()
        {
            return Enum.Parse<Status>(Status);
        }

        public Response ToResponse()
        {
            Response response = Response.GetResponse();
            response.Id = Guid.NewGuid().ToString();
            Gs1Response gs1Response = Gs1ResponseMessage.GS1Response[1];
            if (gs1Response.OriginatingMessageIdentifier != null) response.Id = gs1Response.OriginatingMessageIdentifier.Value;
            if (Gs1ResponseMessage.StandardBusinessDocumentHeader?.DocumentIdentification?.CreationDateAndTime != null)
            {
                response.TimeStamp = Gs1ResponseMessage.StandardBusinessDocumentHeader.DocumentIdentification.CreationDateAndTime;
            }

            List<Gs1.Transaction> transactions = [];

            if (gs1Response.GS1Exception != null)
            {
                response.Status = StatusType.ERROR;
                Gs1.Transaction transaction = new() { Id = response.Id, Status = TransactionStatusType.REJECTED };
                List<Event> events = [];
                foreach (Gs1Exception exception in gs1Response.GS1Exception)
                {
                    //events.Add(new() { Id = exception.GS1Error })
                }


            }
            else
            {
                if (gs1Response.TransactionResponse == null)
                {
                    return response;
                }

                List<TransactionException> transactionExceptions = [];
                if (gs1Response.TransactionException != null) transactionExceptions.AddRange(gs1Response.TransactionException);

                foreach (TransactionResponse transactionResponse in gs1Response.TransactionResponse)
                {
                    Gs1.Transaction transaction = new() { Id = transactionResponse.TransactionIdentifier.Value, Status = Enum.Parse<TransactionStatusType>(transactionResponse.ResponseStatusCode) };
                    if (transaction.Status == TransactionStatusType.REJECTED) response.Status = StatusType.ERROR;

                    TransactionException exception = transactionExceptions.Find(e => e.EntityIdentification.Value == transaction.Id);
                    if (exception != null && exception.GS1Error != null)
                    {
                        List<Event> events = [];
                        foreach (Gs1Error error in exception.GS1Error)
                        {
                            events.Add(new() { Id = error.ErrorCode, Message = error.ErrorDescription, Level = EventLevel.ERROR });
                        }
                        transaction.Events = [.. events];
                    }
                    transactions.Add(transaction);
                }
            }

            response.Transactions = [.. transactions];
            return response;
        }

    }

    internal class Gs1ResponseMessage
    {
        public Gs1Response[] GS1Response { get; set; }
        public StandardBusinessDocumentheader StandardBusinessDocumentHeader { get; set; }
    }

    internal class StandardBusinessDocumentheader
    {
        public DocumentIdentification DocumentIdentification { get; set; }
    }

    internal class DocumentIdentification
    {
        public DateTime CreationDateAndTime { get; set; }
    }

    internal class Gs1Response
    {
        public TransactionException[] TransactionException { get; set; }
        public MessageException[] MessageException { get; set; }
        public EntityIdentification OriginatingMessageIdentifier { get; set; }
        public TransactionResponse[] TransactionResponse { get; set; }
        public Gs1Exception[] GS1Exception { get; set; }
    }

    internal class TransactionException
    {
        public EntityIdentification EntityIdentification { get; set; }
        public Gs1Error[] GS1Error { get; set; }
    }

    internal class EntityIdentification
    {
        public string Value { get; set; }
    }

    internal class Gs1Error
    {
        public string ErrorCode { get; set; }
        public string ErrorDescription { get; set; }
    }


    internal class MessageException
    {
        public Gs1Error[] GS1Error { get; set; }
    }


    internal class TransactionResponse
    {
        public EntityIdentification TransactionIdentifier { get; set; }
        public string ResponseStatusCode { get; set; }
    }


    internal class Gs1Exception
    {
        public Gs1Error[] GS1Error { get; set; }
    }
}
