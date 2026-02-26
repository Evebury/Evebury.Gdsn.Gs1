using Evebury.Gdsn.Gs1.Message;
using Evebury.Gdsn.Gs1.Xml;
using Evebury.Gdsn.Gs1.Xml.Compare;
using Evebury.Gdsn.Gs1.Xml.Schema;
using Evebury.Gdsn.Gs1.Xml.Serialization;
using Evebury.Gdsn.Gs1.Xml.Xsl;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Xml;

namespace Evebury.Gdsn.Gs1
{
    /// <summary>
    /// Gs1 validator for schema, compare and rule validations
    /// </summary>
    public class Gs1Validator
    {

        #region buffers
        private readonly Dictionary<MessageKey, XmlSchemaSet> _schemas = [];
        private readonly Dictionary<MessageKey, XslDocument> _rules = [];
        private readonly Dictionary<MessageKey, XslDocument> _auxiliary = [];
        private readonly Xsl.ResponseExtension _extension = new();
        #endregion

        /// <summary>
        /// Validates a Gs1 message. Will first apply the schema then do a compare and finally apply any applicable business rule.
        /// If any step fails a direct error response is returned
        /// </summary>
        /// <param name="message">The gs1 message</param>
        /// <param name="previous">Optional previously succesfully send message to the gs1 api</param>
        /// <returns cref="Response"></returns>
        /// <exception cref="MessageException"></exception>
        public async Task<Response> Validate(XmlDocument message, XmlDocument previous = null)
        {
            ArgumentNullException.ThrowIfNull(message);

            MessageKey key = MessageKey.GetKey(message);
            Response response;

            if (IsDefinedSchema(key))
            {
                response = await ApplySchema(key, message);
                if (response.Status == StatusType.ERROR) return response;
            }
            else
            {
                //schema should be defined for all gs1 message keys
                throw new MessageException(key);
            }

            if (previous != null)
            {
                Response compare = Equals(message, previous);
                //return if Ok this indicates both messages are equal
                if (compare.Status == StatusType.OK)
                {
                    return compare;
                }
            }

            //do not throw message exception rules do not apply to all message types
            if (IsDefinedRuleSet(key))
            {
                response = await ApplyRules(key, message, previous);
            }

            return response;
        }


        internal async Task<Response> Validate(MessageKey key, XmlDocument message, XmlDocument previous)
        {
            Response response;

            if (IsDefinedSchema(key))
            {
                response = await ApplySchema(key, message);
                if (response.Status == StatusType.ERROR) return response;
            }
            else
            {
                //schema should be defined for all implemented message keys
                throw new MessageException(key);
            }

            if (previous != null)
            {
                Response compare = Equals(message, previous);
                //return if Ok this indicates both messages are equal
                if (compare.Status == StatusType.OK) return compare;
            }

            //do not throw message exception rules do not apply to all message types
            if (IsDefinedRuleSet(key))
            {
                response = await ApplyRules(key, message, previous);
            }

            return response;
        }

        /// <summary>
        /// Applies a schema to the specified message
        /// </summary>
        /// <param name="message">Gs1 message</param>
        /// <returns cref="Response"></returns>
        /// <exception cref="ArgumentNullException">if message is null</exception>
        /// <exception cref="MessageException">if message is not a gs1 message</exception>
        public Task<Response> ApplySchema(XmlDocument message)
        {
            ArgumentNullException.ThrowIfNull(message);
            MessageKey key = MessageKey.GetKey(message);
            if (!IsDefinedSchema(key)) throw new MessageException(key);
            return ApplySchema(key, message);
        }

        private bool IsDefinedSchema(MessageKey key)
        {
            if (key.Type == MessageType.NotDefined) return false;

            //set index key to message type there is one schema for all messages of said type
            MessageKey index = new()
            {
                Type = key.Type,
                Version = key.Version,
            };

            if (_schemas.TryGetValue(index, out _)) return true;
            switch (key.Version)
            {
                case 3:
                    {
                        XmlSchemaSet schema = XmlSchemaSet.Load(R3.Schema.CatalogueItem.Resource.ResourceManager);
                        _schemas.Add(index, schema);
                        return true;
                    }
                default:
                    {
                        return false;
                    }
            }
        }

        private async Task<Response> ApplySchema(MessageKey key, XmlDocument message)
        {
            _schemas.TryGetValue(key, out XmlSchemaSet schema);
            XmlSchemaValidator validator = new();
            XmlSchemaValidatorResult result = await validator.Validate(message, schema);
            return Response.GetResponse(result);
        }


        /// <summary>
        /// Compares two Gs1 messages
        /// </summary>
        /// <param name="message">Gs1 message</param>
        /// <param name="previous">Gs1 message if null returns false</param>
        /// <returns cref="Response">status set OK on equals otherwise ERROR</returns>
        /// <exception cref="ArgumentNullException">if message is null</exception>
        public static Response Equals(XmlDocument message, XmlDocument previous)
        {
            ArgumentNullException.ThrowIfNull(message);
    
            if (previous == null) return Response.GetResponse(false);


            MessageKey key = MessageKey.GetKey(message);

            XPaths paths = null;

            if (key.Type == MessageType.CatalogueItem)
            {
                List<XmlNamespace> namespaces = [];
                namespaces.Add(new("gs1", key.NamespaceUri));
                namespaces.Add(new("sh", "http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"));

                //ignore all timestamps and entityIdentification 
                List<XPath> xpaths = GetXPaths(key);
                if (key == MessageKey.CatalogueItemNotification3)
                {
                    xpaths.Add(new XPath("/gs1:catalogueItemNotificationMessage//tradeItemSynchronisationDates/lastChangeDateTime"));
                    xpaths.Add(new XPath("/gs1:catalogueItemNotificationMessage//tradeItemSynchronisationDates/effectiveDateTime"));
                    xpaths.Add(new XPath("/gs1:catalogueItemNotificationMessage//tradeItemSynchronisationDates/publicationDateTime"));
                }
                paths = new(xpaths, namespaces);
            }

            string hash1 = XmlCompare.GetHashCode(message, paths);
            string hash2 = XmlCompare.GetHashCode(previous, paths);
            Response response = Response.GetResponse(hash1 == hash2);
            response.SetVersion(key.Version);
            return response;
        }

        private static List<XPath> GetXPaths(MessageKey key)
        {
            List<XPath> xpaths = [];
            xpaths.Add(new XPath($"/gs1:{key.Message}/sh:StandardBusinessDocumentHeader/CreationDateAndTime"));
            xpaths.Add(new XPath($"/gs1:{key.Message}/sh:StandardBusinessDocumentHeader/InstanceIdentifier"));
            xpaths.Add(new XPath($"/gs1:{key.Message}/transaction/transactionIdentification/entityIdentification"));
            xpaths.Add(new XPath($"/gs1:{key.Message}/transaction/documentCommand/documentCommandHeader/documentCommandIdentification/entityIdentification"));
            xpaths.Add(new XPath($"/gs1:{key.Message}/transaction/documentCommand/gs1:{key.Element}/creationDateTime"));
            xpaths.Add(new XPath($"/gs1:{key.Message}/transaction/documentCommand/gs1:{key.Element}/lastUpdateDateTime"));
            xpaths.Add(new XPath($"/gs1:{key.Message}/transaction/documentCommand/gs1:{key.Element}/{key.Element}Identification/entityIdentification"));
            return xpaths;
        }



        /// <summary>
        /// Applies rules to the specified message
        /// </summary>
        /// <param name="message">Gs1 message</param>
        /// <param name="previous">Last Gs1 message successfully send to Gs1. Can be set to null</param>
        /// <returns cref="Response"></returns>
        /// <exception cref="ArgumentNullException">if message is null</exception>
        /// <exception cref="MessageException">if message is not a gs1 message</exception>
        public Task<Response> ApplyRules(XmlDocument message, XmlDocument previous = null)
        {
            ArgumentNullException.ThrowIfNull(message);
            MessageKey key = MessageKey.GetKey(message);
            if (!IsDefinedRuleSet(key)) throw new MessageException(key);
            return ApplyRules(key, message, previous);

        }

        private bool IsDefinedRuleSet(MessageKey key)
        {
            if (_rules.TryGetValue(key, out _)) return true;

            if (key == MessageKey.CatalogueItemNotification3)
            {
                _auxiliary.Add(key, XslDocument.Load(R3.Xsl.CatalogueItem.XslResource.current));
                _rules.Add(key, XslDocument.Load(R3.Xsl.CatalogueItem.CatalogueItem.ResourceManager));
                return true;
            }
            return false;
        }

        private async Task<Response> ApplyRules(MessageKey key, XmlDocument message, XmlDocument previous)
        {
            XslDocument xsl;
            List<XslParameter> parameters = [];

            if (previous != null)
            {
                _auxiliary.TryGetValue(key, out xsl);
                parameters = [];
                XmlDocument current = await xsl.Transform(previous);
                parameters.Add(new("current", current));

            }

            _rules.TryGetValue(key, out xsl);

            XmlDocument xml = await xsl.Transform(message, parameters, [_extension]);
            Response response = await XmlSerializer.Deserialize<Response>(xml);
            response.SetVersion(key.Version);
            return response;
        }


        /// <summary>
        /// Converts a gS1ResponseMessage to a Response
        /// </summary>
        /// <param name="gs1ResponseMessage">the gs1 response message</param>
        /// <returns cref="Response"></returns>
        /// <exception cref="MessageException">if not defined</exception>
        /// <exception cref="ArgumentNullException">if gs1ResponseMessage is null</exception>
        public async Task<Response> ConvertGs1Response(XmlDocument gs1ResponseMessage)
        {
            ArgumentNullException.ThrowIfNull(gs1ResponseMessage);
            MessageKey key = MessageKey.GetKey(gs1ResponseMessage);
            if (!IsDefinedResponse(key)) throw new MessageException(key);

            _auxiliary.TryGetValue(key, out XslDocument xsl);
            XmlDocument response = await xsl.Transform(gs1ResponseMessage, null, [_extension]);
            return await XmlSerializer.Deserialize<Response>(response);
        }

        private bool IsDefinedResponse(MessageKey key)
        {
            if (_auxiliary.TryGetValue(key, out _)) return true;
            if (key == MessageKey.Gs1Response3)
            {
                _auxiliary.Add(key, XslDocument.Load(R3.Xsl.CatalogueItem.XslResource.gs1Response));
                return true;
            }
            return false;
        }

        /// <summary>
        /// Clears all buffers
        /// </summary>
        public void ClearBuffer()
        {
            _schemas.Clear();
            _rules.Clear();
            _auxiliary.Clear();
            _extension.ClearBuffer();
        }
    }
}
