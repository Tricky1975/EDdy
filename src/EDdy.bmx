Rem
	EDdy
	Very simplistic CLI based text editor
	
	
	
	(c) Jeroen P. Broks, 2017, All rights reserved
	
		This program is free software: you can redistribute it and/or modify
		it under the terms of the GNU General Public License as published by
		the Free Software Foundation, either version 3 of the License, or
		(at your option) any later version.
		
		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.
		You should have received a copy of the GNU General Public License
		along with this program.  If not, see <http://www.gnu.org/licenses/>.
		
	Exceptions to the standard GNU license are available with Jeroen's written permission given prior 
	to the project the exceptions are needed for.
Version: 17.04.12
End Rem
Strict

Framework tricky_units.Listfile

MKL_Version "EDdy - EDdy.bmx","17.04.12"
MKL_Lic     "EDdy - EDdy.bmx","GNU General Public License 3"


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

Function Help(P$)
	P=Trim(P)
	If Not P
		For Local k$=EachIn MapKeys(EDdyM) Help k Next
	Else
		If MapContains(EDdyM,Upper(p))
			Print p+"~n~t"+TEDdyCommand(MapValueForKey(EDdyM,Upper(p))).Help$
		Else
			Print "ERROR: That command doesn't exist so no help is available about it either."
		EndIf	
	EndIf
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
		ElseIf n="" Or Upper(n)="ALL"
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

Function Del(P$)
	Local l[] = linenumbers(p)
	If Len(l)>5 Or Len(l)>=CountList(data)
		Print "WARNING! You are about to remove a huge portion of the file, if not the entire content"
		If Left(Upper(Trim(Input("Are you sure ? (Y/N) "))),1)<>"Y" Return
	EndIf
	Local newdata:TList = New TList
	Local keep
	For Local i=0 Until CountList(data)
		keep=True
		DebugLog "LINE: "+i
		For Local i2=EachIn l
			keep = keep And i<>i2
			DebugLog "CHECK: "+i2+" KEEP: "+Keep+"   ("+Int(i<>i2)+")"
		Next
		If keep ListAddLast newdata,data.valueatindex(i)
	Next
	data=newdata
End Function	

Function Insert(P$)
	p=Trim(p)
	Local ps = p.find(" ")
	If ps=-1 Print "ERROR: Invalid input!";Return
	Local l=(p[..ps]).toint()
	Local t$=p[ps+1..]
	Local newdata:TList = New TList
	For Local i=0 Until CountList(data)
		If i=l ListAddLast newdata,t
		ListAddLast newdata,data.valueatindex(i)
	Next
	data=newdata
End Function

Function ReplaceLine(p$)
	p=Trim(p)
	Local ps = p.find(" ")
	If ps=-1 Print "ERROR: Invalid input!";Return
	Local l[]=linenumbers(p[..ps])
	Local newdata:TList = New TList
	For Local i=0 Until CountList(data)
		Local change
		For Local i2=EachIn l
			change = change Or i2=i
		Next
		If change
			ListAddLast newdata,p[ps+1..]
		Else
			ListAddLast newdata,data.valueatindex(i)
		EndIf	
	Next
	data=newdata	
End Function

Function Search(p$)
	Local l$ = ""
	For Local i=0 Until CountList(data)
		If String(data.valueatindex(i)).find(p)>-1
			If l l:+","
			l:+i
		EndIf
	Next
	list(l)
End Function

eddyadd "Q",Quit,"Saves and quits EDdy"
eddyadd "BYE",quit,"Saves and quits EDdy"
eddyadd "CRASH",Crash,"Quits EDdy immediately without saving"
eddyadd "A",Add,"Adds a line of text to the end of the text"
eddyadd "L",List,"Lists content"
eddyadd "HELP",HELP,"List of commands And their purposes"
eddyadd "D",del,"Deletes a line or multiple lines from the text"
eddyadd "I",insert,"Inserts a line"
eddyadd "S",save,"Saves the file"
eddyadd "REPLINE",ReplaceLine,"Replaces a line or multiple lines with new text"
eddyadd "SEARCH",Search,"Seaches for text (case sensitive)"

Print "EDdy - Coded by Tricky"
Print "Version "+MKL_NewestVersion()
Print "(c) Jeroen P. Broks"
If (Len AppArgs)<=1 
	Print "~n~nusage "+StripAll(AppFile)+" <file>"
	End
EndIf

ChangeDir LaunchDir

Global file$ = AppArgs[1]
Global BT:TStream

If Not FileType(file)
	Print file+" does not exist."
	If Left(Trim(Upper(Input("Create it ? (Y/N) "))),1)="Y" 
		BT = WriteFile(file)
		If Not bt Print "ERROR: Couldn't create the file!" End
		CloseFile BT		
	Else
		End	
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
	

	
