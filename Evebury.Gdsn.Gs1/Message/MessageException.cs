using System;

namespace Evebury.Gdsn.Gs1.Message
{

    /// <summary>
    /// Exception thrown when message is not defined for current operation
    /// </summary>
    public class MessageException : Exception
    {
        internal MessageException(MessageKey key) :base($"Message is not defined for current operation: {key.Message} {key.NamespaceUri}")
        { 
        }
    }
}
