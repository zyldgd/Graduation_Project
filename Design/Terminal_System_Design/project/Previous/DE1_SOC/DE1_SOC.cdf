/* Quartus II 64-Bit Version 13.1.0 Build 162 10/23/2013 SJ Web Edition */
JedecChain;
	FileRevision(JESD32A);
	DefaultMfr(6E);

	P ActionCode(Ign)
		Device PartName(SOCVHPS) MfrSpec(OpMask(0));
	P ActionCode(Cfg)
		Device PartName(5CSEMA5) Path("E:/GithubRepository/SOC/project/DE1_SOC/") File("output_file.jic") MfrSpec(OpMask(1) SEC_Device(EPCQ256) Child_OpMask(1 3));

ChainEnd;

AlteraBegin;
	ChainType(JTAG);
AlteraEnd;
