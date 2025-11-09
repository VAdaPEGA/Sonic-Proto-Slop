using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Drawing;
using SonicRetro.SonLVL.API;

namespace S2ObjectDefinitions.HPZ
{
	class HPZBridge : ObjectDefinition
	{
		private Sprite imghpzbridge;

		public override void Init(ObjectData data)
		{
			byte[] artfile = ObjectHelper.OpenArtFile("../source/Objects/Bridge/Bridge_HPZ.ArtNem", CompressionType.Nemesis);
			byte[] mapfile = System.IO.File.ReadAllBytes("../source/Objects/Bridge/Bridge_HPZ.SprMap");
			imghpzbridge = ObjectHelper.MapToBmp(artfile, mapfile, 0, 3);
		}

		public override ReadOnlyCollection<byte> Subtypes
		{
			get { return new ReadOnlyCollection<byte>(new byte[] { 8, 10, 12, 14, 16 }); }
		}

		public override string Name
		{
			get { return "HPZBridge"; }
		}

		public override byte DefaultSubtype
		{
			get { return 8; }
		}

		public override string SubtypeName(byte subtype)
		{
			return (subtype & 0x1F) + " loogs";
		}

		public override Sprite Image
		{
			get { return imghpzbridge; }
		}

		public override Sprite SubtypeImage(byte subtype)
		{
			return imghpzbridge;
		}

		public override Sprite GetSprite(ObjectEntry obj)
		{
			int st = -(((obj.SubType & 0x1F) * imghpzbridge.Width) / 2);
			List<Sprite> sprs = new List<Sprite>();
			for (int i = 0; i < (obj.SubType & 0x1F); i++)
			{
				Sprite tmp = new Sprite(imghpzbridge);
				tmp.Offset(st + (i * imghpzbridge.Width), 0);
				sprs.Add(tmp);
			}
			return new Sprite(sprs.ToArray());
		}
	}
}
