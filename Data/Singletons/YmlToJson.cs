using Godot;
using System;
using System.IO;
using System.Text;
using YamlDotNet.Serialization;

public partial class YmlToJson : Node
{
	public static string Convert(string filename) 
	{
		try 
		{
			using var file = Godot.FileAccess.Open(filename, Godot.FileAccess.ModeFlags.Read);
			string content = file.GetAsText();
			var r = new StringReader(content); 
			var deserializer = new Deserializer();
			var yamlObject = deserializer.Deserialize(r);
			var serializer = new SerializerBuilder()
					.JsonCompatible()
					.Build();
			var json = serializer.Serialize(yamlObject);
			return json;
		}
		catch (Exception e)	
		{
			GD.Print(e.Message);
		}
		return "";
	}
}

