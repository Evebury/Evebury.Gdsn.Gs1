namespace Evebury.Gdsn.Gs1.R3.Gpc
{
    internal struct BrickPath(string segment, string family, string @class)
    {
        public string Segment { get; set; } = segment;

        public string Family { get; set; } = family;

        public string Class { get; set; } = @class;
    }
}
