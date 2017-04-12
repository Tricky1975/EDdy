Strict

Framework tricky_units.Listfile

MKL_Version "",""
MKL_Lic     "","" ' Will be filled out later.


Global data:TList

Type TEDdyCommand
	Field func(p$)
	Field Help$
End Type

Global EDdyM:TMap = New TMap

Function EDdyAdd(c$,f(p$),H$)
	Local E:TEDdyCommand = New TEDdyCommand
	E.func = f
	E.Help = H
	MapInsert EDdyM,Upper(c),E
End Function

Function Quit(p$)
	Save p
	Print "Ending"
	End
End Function

Function Crash(p$)
	Print "Crashing out!"
	End
End Function

Function Save(p$)
	Print "Saving "+file
	BT = WriteFile(file)
	For Local l$=EachIn data
		WriteLine bt,l
	Next
	CloseFile BT
End Function

Function Add(p$)
	ListAddLast data,p
End Function

Function LineNumbers[](p$)
	Local ak
	Local RET$
	Local num$[] = p.split(",")
	For Local N$=EachIn num
		If Left(n,1)="-" 
			For ak=1 To Right(n.toint(),(Len(n)-1)).toint()
				If Ret ret:+","
				ret:+ak
			Next
		ElseIf Right(n,1)="-"
			For ak=Left(n,Len(n)-1).toint() Until CountList(data)
				If Ret ret:+","
				ret:+ak
			Next
		ElseIf n.find("-")>-1
			Local r$[]=n.split("-")
			Local f=r[0].toint()
			Local e=r[1].toint()
			If f<e 
				For ak=f To e
					If Ret ret:+","
					ret:+ak
				Next
			Else
				For ak=e To f Step -1
					If Ret ret:+","
					ret:+ak
				Next
			EndIf
		ElseIf n=""
			For ak=0 Until CountList(data)
				If Ret ret:+","
				ret:+ak
			Next
		Else
			ret=p
		EndIf
	Next	
	Local r$[]=ret.split(",")
	Local fr[] = New Int[Len r]
	For ak=0 Until Len r
		fr[ak]=r[ak].toint()		
	Next
	Return fr
End Function

Function List(p$)
	Local l[] = linenumbers(p)
	Local m=CountList(data)
	For Local li=EachIn l
		If li<m
			Print Right("      "+li,5)+":"+String(data.valueatindex(li))
		EndIf
	Next
End Function

eddyadd "Q",Quit,"Saves and quits EDdy"
eddyadd "BYE",quit,"Saves and quits EDdy"
eddyadd "CRASH",Crash,"Quits EDdy immediately without saving"
eddyadd "A",Add,"Adds a line of text to the end of the text"
eddyadd "L",List,"Lists content"

Print "EDdy - Coded by Tricky"
Print "Version "+MKL_NewestVersion()
Print "(c) Jeroen P. Broks"
If (Len AppArgs)<=1 
	Print "~n~nusage "+StripAll(AppFile)+" <file>"
	End
EndIf

Global file$ = AppArgs[1]
Global BT:TStream

If Not FileType(file)
	Print file+" does not exist."
	If Left(Trim(Upper(Input("Create it ? (Y/N) "))),1)="Y" 
		BT = WriteFile(file)
		If Not bt Print "ERROR: Couldn't create the file!" End
		CloseFile BT		
	EndIf
EndIf

data:TList = Listfile(file)
Print "File ~q"+file+"~q has "+CountList(data)+" lines of data"
Global cli$
Global cmd$,para$,pos
Repeat
	cli$=Trim(Input(":"))
	pos = cli.find(" ")
	If pos=-1 
		cmd=cli; para=""
	Else
		cmd=cli[..pos];
		para=cli[pos+1..]
	EndIf
	cmd=Upper(cmd)
	If MapContains(EDdyM,cmd)
		TEDdyCommand(MapValueForKey(EDdyM,cmd)).func(para)
	Else
		Print "? I don't understand "+cmd
	EndIf
Forever	
	

	
