using System.Xml;

namespace Evebury.Gdsn.Gs1.Test
{
    [TestClass]
    public sealed class CatalogueItemNotification
    {
        [TestMethod]
        public async Task Validate()
        {
            XmlDocument message = new();
            message.Load("CatalogueItemNotification.xml");
            Gs1Validator validator = new();
            Response response = await validator.Validate(message);
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
        public async Task ApplyRules()
        {
            XmlDocument message = new();
            message.Load("CatalogueItemNotificationRule.xml");
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
            Assert.AreEqual("448", eventId);
        }
    }
}
