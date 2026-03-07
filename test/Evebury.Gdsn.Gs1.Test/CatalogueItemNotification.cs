using Evebury.Gdsn.Gs1.Message;
using System.Threading.Tasks;
using System.Xml;

namespace Evebury.Gdsn.Gs1.Test
{
    [TestClass]
    public sealed class CatalogueItemNotification
    {
        private XmlDocument Message
        {
            get
            {
                if (field is null)
                {
                    XmlDocument message = new();
                    message.Load("CatalogueItemNotification.xml");
                    field = message;
                }
                return field;
            }
        }

        [TestMethod]
        public async Task Validate()
        {
            Gs1Validator validator = new();
            Response response = await validator.Validate(Message);
            Assert.AreEqual(StatusType.OK, response.Status, "All validations should pass");
        }

        [TestMethod]
        public async Task ApplySchema()
        {
            XmlDocument message = new();
            message.Load("CatalogueItemNotificationSchema.xml");
            Gs1Validator validator = new();
            Response response = await validator.Validate(message);
            string eventId = string.Empty;
            if (response.Transactions != null && response.Transactions.Length > 0)
            {
                Transaction transaction = response.Transactions[0];
                if (transaction.Events != null && transaction.Events.Length > 0)
                {
                    eventId = transaction.Events[0].Id;
                }
            }
            Assert.AreEqual("xml_schema", eventId);
        }

        [TestMethod]
        public void ApplyCompare()
        {

            //compare has different dates
            XmlDocument compare = new();
            compare.Load("CatalogueItemNotificationCompare.xml");

            Response response = Gs1Validator.Compare(Message, compare);
            Assert.AreEqual(StatusType.OK, response.Status, "Dates will not apply on equality");
        }

        [TestMethod]
        public async Task ApplyRules()
        {
            XmlDocument message = new();
            message.Load("CatalogueItemNotificationRule.xml");
            Gs1Validator validator = new();
            Response response = await validator.ApplyRules(message);
            response.Localize(new System.Globalization.CultureInfo("nl"));
            string eventId = string.Empty;
            string label = string.Empty;
            if (response.Transactions != null && response.Transactions.Length > 0)
            {
                Transaction transaction = response.Transactions[0];
                if (transaction.Events != null && transaction.Events.Length > 0)
                {
                    Event @event = transaction.Events[0];
                    eventId = @event.Id;
                    if (@event.Data != null && @event.Data.Length > 0)
                    {
                        label = @event.Data[0].Label;
                    }

                }
            }
            Assert.AreEqual("Informatieprovider", label);
            Assert.AreEqual("448", eventId);
        }

        [TestMethod]
        public async Task Previous()
        {

            XmlDocument previous = new();
            previous.Load("CatalogueItemNotificationPrevious.xml");

            Gs1Validator validator = new();
            Response response = await validator.Validate(Message, previous);
            Assert.AreEqual(StatusType.ERROR, response.Status, "A validation rule should have be triggered");
        }

        [TestMethod]
        public async Task NotImplemented()
        {
            XmlDocument message = new();
            message.Load("NotImplemented.xml");
            bool isValid = true;
            try
            {
                Gs1Validator validator = new();
                await validator.Validate(message);
            }
            catch (MessageException) 
            { 
                isValid = false;
            }
            Assert.IsFalse(isValid);
        }
    }
}
