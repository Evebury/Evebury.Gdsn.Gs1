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
            response.Localize(new System.Globalization.CultureInfo("nl"));
            string transactionId = "";
            if (response.Transactions != null && response.Transactions.Length >= 1) 
            {
                transactionId = response.Transactions[0].Id;
            }
            //if transaction id is set message is valid schema and rules are applied
            Assert.AreEqual("20051101", transactionId);
            Assert.AreEqual(StatusType.ERROR, response.Status);
        }

        [TestMethod]
        public async Task Schema()
        {
            XmlDocument message = new();
            message.Load("CatalogueItemNotificationInvalid.xml");
            Gs1Validator validator = new();
            Response response = await validator.Validate(message);
            string transactionId = "";
            if (response.Transactions != null && response.Transactions.Length >= 1)
            {
                transactionId = response.Transactions[0].Id;
            }
            //if schema fails transactionId is set to "validation_reponse"
            Assert.AreNotEqual("20051101", transactionId);
            Assert.AreEqual(StatusType.ERROR, response.Status);
        }
    }
}
