( MUFopoly MUF by Tursi - Gfx by Marjan )
( Written for FlipSide Muck )
 
( This program may be used on other mucks so long no credits are altered or removed )
( This program must be set at least M3. After compiling the program and setting it  )
( W or M3, create a room for the game to run in - game data and commands are stored )
( in the room.                                                                      )
( In the new room, run the program with the argument '#install' to set it up. You   )
( must own the program to run #install. At that point, the game is ready to run.    )
( A Wiz bit is preferred, however, the game *should* run at most mucks with an M3.  )
( Be warned that with less than an M3 the game may not run reliably on all mucks:   )
( -Instruction count per command can be very high                                   )
( -'new' command calls NEXTPROP to remove obsolete games, requires M3 on some mucks )
(  'trading' also uses it to enumerate stored and pending trades                    )
( -Program 'CALL's itself to provide recursive calls for Chance and Comm. Chest     )
(  If they are broken, make sure it's set Linkable and the program has sufficient   )
(  permission for call                                                              )
( -Default storage prop is actually a Wiz prop using ~ so players can not cheat!    )
(  You WILL need to change this to run with M3                                      )
( -It's acceptable to set up multiple rooms on the same program.                    )
( You can have custom board sets - Just create a string with 40 space-separated     )
( strings, and set it on the room as 'Setx', where x>0. Start a game as 'New x' to  )
( use a custom set. Name the sets with the prop 'Namex'                             )
( )
( The following bugs/features are known: )
( -There are no Auctions )
( -You can not identify game by player who started it, only by number )
( -You can not identify squares by name prefix, only by number )
( -There is no 10% bank fee when trading mortgaged properties )
( -Free Parking always collects money )
( -Even property development across a group is not enforced )
( -After mortgaging a property, you may buy houses on other properties in the same group )
( -Retiring returns your properties to the bank, not to the player who bankrupted you )
 
( -- Standard Notice --                                              )
(  Copyright 2011 Mike Brent aka Tursi aka HarmlessLion.com          )
(  This software is provided AS-IS. No warranty                      )
(  express or implied is provided.                                   )
(  )
(  This notice defines the entire license for this code.             )
(  All rights not explicity granted here are reserved by the         )
(  author. )
(  )
(  You may redistribute this software provided the original          )
(  archive is UNCHANGED and a link back to my web page,              )
(  http://harmlesslion.com, is provided as the author's site.        )
(  It is acceptable to link directly to a subpage at harmlesslion.com)
(  provided that page offers a URL for that purpose                  )
(  )
(  Source code, if available, is provided for educational purposes   )
(  only. You are welcome to read it, learn from it, mock             )
(  it, and hack it up - for your own use only.                       )
(  )
(  Please contact me before distributing derived works or            )
(  ports so that we may work out terms. I don't mind people          )
(  using my code but it's been outright stolen before. In all        )
(  cases the code must maintain credit to the original author<s>.    )
(  )
(  Addendum to the above paragraph for MUF code:                     )
(  You may modify the software as required to port it to your own    )
(  system and offer the functionality publically, including sharing  )
(  the source with owners of similar systems, provided no functional )
(  changes are made. You may not offer the modified software for     )
(  download, place on CD, or distribute by any automated or          )
(  commercial means without approval from the author.                )
(  )
(  You may further modify the code for use on your own system and    )
(  make the resultant functionality available to users of your       )
(  system, however, you are requested not to distribute the modified )
(  version at all. You are encouraged to submit your changes to the  )
(  author for incorporation into the official version, where         )
(  appropriate.                                                      )
(  )
(  -COMMERCIAL USE- Contact me first. I didn't make                  )
(  any money off it - why should you? ;> If you just learned         )
(  something from this, then go ahead. If you just pinched           )
(  a routine or two, let me know, I'll probably just ask             )
(  for credit. If you want to derive a commercial tool               )
(  or use large portions, we need to talk. ;>                        )
(  )
(  Addendum to the above paragraph for MUF code:                     )
(  This software's functionality may be offered publically on a      )
(  commercial server provided that no additional charge is made to   )
(  use it, and no modifications beyond that necessary to port the    )
(  software are made. The author would like to be notified of any    )
(  commercial server using his software and be offered an opportunity)
(  to verify the installation.                                       )
(  )
(  If this, itself, is a derived work from someone else's code,      )
(  then their original copyrights and licenses are left intact       )
(  and in full force.                                                )
(  )
(  http://harmlesslion.com - visit the web page for contact info     )
 
$include $lib/reflist
 
( Uncomment this to use lib/ansi codes instead of glowmuck codes.    )
( It's a hacky compatibility layer, so slightly slower, but it works )
( $def USE_LIB_ANSI )
 
( Generic muck interface stuff )
( prop to store player-related game info on - player should not be able to alter it )
( to avoid cheating - note that a wizprop will cause the game to require a wizbit )
$def PLAYERPROP "/~Games/MUFopoly/"
 
( Object global game info is stored on)
$def GLOBALOBJECT loc @
 
( Prefix to all strings output by the game )
$def GAMEPREFIX "[] "
 
( --- Normally you don't need to change below this... -- )
( game defaults )
$def STARTCASH 1500
$def STARTHOUSES 32
$def STARTHOTELS 12
$def STARTPARKING 500
 
( there are forty spaces on the board - this defines information about each )
 
( Types: a=property b=comm.chest c=income tax d=railroad e=chance f=jail g=utility )
( h=free parking i=go to jail j=luxury tax k=go )
$def TYPES    "K A B A C D A E A A F A G A A D A B A A H A E A A D A A G A I A A B A D E A J A"
 
( names of the spaces )
( Use '_' to indicate a line break space - first one only counts )
( Use '~' to indicate a space that must not break lines )
( 'Ave' becomes 'Avenue' on mortgage side automatically )
( Note: the '~&' in here are safe because the tildes are stripped before printing )
$define SPACES   "Set" GetGameVal dup 0 = if 
                   pop "GO Mediterranean_Ave Community_Chest Baltic_Ave Income_Tax Reading_Railroad Oriental_Ave Chance Vermont_Ave Connecticut_Ave Jail_(Just~Visiting) St.~Charles_Place Electric_Company States_Ave Virginia_Ave Pennsylvania_Railroad St.~James_Place Community_Chest Tennessee_Ave New~York_Ave Free_Parking Kentucky_Ave Chance Indiana_Ave Illinois_Ave B~&~O_Railroad Atlantic_Ave Ventnor_Ave Water_Works Marvin_Gardens Go~to_Jail Pacific_Ave North~Carolina_Ave Community_Chest Pennsylvania_Ave Short_Line Chance Park_Place Luxury_Tax Boardwalk_" 
				 else
				   intostr "Set" swap strcat loc @ swap GetPropStr
				 then
$enddef
 
( Basic property - all prices are 4 digits for convenience, not necessity )
 
( Rent with 0 houses )
$def RENT0    "x 0002 x 0004 x x 0006 x 0006 0008 x 0010 x 0010 0012 x 0014 x 0014 0016 x 0018 x 0018 0020 x 0022 0022 x 0024 x 0026 0026 x 0028 x x 0035 x 0050"
 
( Rent with 1 house )
$def RENT1    "x 0010 x 0020 x x 0030 x 0030 0040 x 0050 x 0050 0060 x 0070 x 0070 0080 x 0090 x 0090 0100 x 0110 0110 x 0120 x 0130 0130 x 0150 x x 0175 x 0200"
 
( Rent with 2 houses )
$def RENT2    "x 0030 x 0060 x x 0090 x 0090 0100 x 0150 x 0150 0180 x 0200 x 0200 0220 x 0250 x 0250 0300 x 0330 0330 x 0360 x 0390 0390 x 0450 x x 0500 x 0600"
 
( Rent with 3 houses )
$def RENT3    "x 0090 x 0180 x x 0270 x 0270 0300 x 0450 x 0450 0500 x 0550 x 0550 0600 x 0700 x 0700 0750 x 0800 0800 x 0850 x 0900 0900 x 1000 x x 1100 x 1400"
 
( Rent with 4 houses )
$def RENT4    "x 0160 x 0320 x x 0400 x 0400 0450 x 0625 x 0625 0700 x 0750 x 0750 0800 x 0875 x 0875 0925 x 0975 0975 x 1025 x 1100 1100 x 1200 x x 1300 x 1700"
 
( Rent with Hotel )
$def RENTH    "x 0250 x 0450 x x 0550 x 0550 0600 x 0750 x 0750 0900 x 0950 x 0950 1000 x 1050 x 1050 1100 x 1150 1150 x 1200 x 1275 1275 x 1400 x x 1500 x 2000"
 
( All property - includes railroads and utilities )
 
( Mortgage value )
$def MORTGAGE "x 0030 x 0030 x 0100 0050 x 0050 0060 x 0070 0075 0070 0080 0100 0090 x 0090 0100 x 0110 x 0110 0120 0100 0130 0130 0075 0140 x 0150 0150 x 0160 0100 x 0175 x 0200"
 
( Purchase price )
$def PURCHASE "x 0060 x 0060 x 0200 0100 x 0100 0120 x 0140 0150 0140 0160 0200 0180 x 0180 0200 x 0220 x 0220 0240 0200 0260 0260 0150 0280 x 0300 0300 x 0320 0200 x 0350 x 0400"
 
( Group information )
 
( Each square - group number from 0-9, railroad is 1, utility is 4 )
$def GROUPS "x 0 x 0 x 1 2 x 2 2 x 3 4 3 3 1 5 x 5 5 x 6 x 6 6 1 7 7 4 7 x 8 8 x 8 1 x 9 x 9"
( See the dojoin function which hard-codes the number of elements in each group )
 
( House prices are indexed by group number )
$def HOUSE  "050 000 050 100 000 100 150 150 200 200"
 
( Square color by group number )
$def COLORS "^violet^ ^normal^ ^cyan^ ^purple^ ^normal^ ^brown^ ^red^ ^yellow^ ^green^ ^blue^"
 
( ------------------- )
 
( Data structures )
( Player: ~Games/MUFopoly/ )
(                         PlayingIn: <game number> )
(                         Location:  <square number> )
(                         InJail:    <0, or number of turns so far> )
(                         JailFree:  <number of 'get out of jail free' cards> )
(                         Groups/0-9:<number of properties not owned in this group> )
(                         Property/1-40: 0=not owned )
(                                        1-5=0-4 houses )
(                                        6=hotel )
(                                        7=mortgaged )
(                         Cash:      <amount> )
(                         Wins:      <number of wins> )
(                         Losses:    <number of losses> )
(                         Aborts:    <number of times dropped out> )
(                         Trades/<player number>/Offer:<str> )
(                                                Wanted:<str> )
(                                                <str> is $cash or properties list )
( )
( Trigger or Room: ~Games/MUFopoloy/ )
(                           NextGame: # )
(                           <game#>/)
(                                   Players: <proplist> )
(                                   Watchers: <proplist> )
(                                   Started: 0 if not started yet, else 1 )
(                                   Turn:    <player #> )
(                                   FreeParking: <amount> )
(                                   Phase:   1-roll, 2-buy, 3-get out of debt )
(                                   DoublesCount: 0-3      )
(                                   LastTurn: <timestamp>  )
(                                   Property/1-40: <player # of owner, or 0> )
(                                   HousesLeft: <count>    )
(                                   HotelsLeft: <count>    )
( )
( Wizard Commands )
( #install: creates the actions in the room to run the game )
( )
 
( I finally had to use a FEW variables to simplify the code... )
var ThisRoll
var ForceNextTurn
var TmpStr
var TmpDebug
var TmpDebug2
var TmpDebug3
var LocalTmp
var LocalTmp2
var LocalTmp3
var RentPenalty
 
( ------------------- )
$ifdef USE_LIB_ANSI
 
$include $lib/ansi
 
( add any other ansi functions used here )
$def ansistrip ansifix ansi_strip
$def notify ansifix ansi_notify
 
( convert glow style codes to lib-ansi )
: ansifix ( s -- s )
  ( because this code doesn't use the background colors, we don't include them for speed's sake )
  "~&000" "^black^" subst
  "~&010" "^crimson^" subst
  "~&020" "^forest^" subst
  "~&030" "^brown^" subst
  "~&040" "^navy^" subst
  "~&050" "^violet^" subst
  "~&060" "^aqua^" subst
  "~&070" "^gray^" subst
 
  "~&100" "^gloom^" subst
  "~&110" "^red^" subst
  "~&120" "^green^" subst
  "~&130" "^yellow^" subst
  "~&140" "^blue^" subst
  "~&150" "^purple^" subst
  "~&160" "^cyan^" subst
  "~&170" "^white^" subst
 
  "~&R"   "^normal^" subst
;
 
$else
 
( Ignore ansifix and fixup ansi_strip )
( I don't know if ansi_strip actually exists at glow mucks? Do you need to strip out ANSI codes? )
$def ansifix
$def ansistrip ansi_strip
 
$endif
 
( Compatibility STRcenter, STRleft and STRright that ignore ANSI and truncate as well as pad )
( Bug: truncation is incorrect if the color tags are in the trimmed area! )
( For center, that's at either end, for left it's at the end, for right it's at the beginning )
: STRcenter ( str width -- str )
  dup -3 rotate
  over ansistrip strlen over over < if
    ( string is too long, trim it )
    swap - 1 + 2 / begin dup while
      swap 
      1 strcut swap pop
      dup strlen 1 - strcut pop
      swap
      1 -
    repeat
  else 
    ( string is too short, pad it )
    - 1 + 2 / begin dup while
      swap
      " " swap strcat " " strcat
      swap
      1 -
    repeat
  then
  pop
  dup ansistrip strlen rot > if 1 strcut swap pop then
;
 
: STRleft ( str width -- str )
  over ansistrip strlen over over < if   (
    ( string is too long, trim it )
	swap - 
	over strlen swap -
    strcut pop
  else
    ( string is too short, pad it )
    - begin dup while
      swap
      " " strcat
      swap
      1 -
    repeat
    pop
  then
;
 
: STRright ( str width -- str )
  over ansistrip strlen over over < if
    ( string is too long, trim it )
    swap - strcut swap pop
  else
    ( string is too short, pad it )
    - begin dup while
      swap
      " " swap strcat
      swap
      1 -
    repeat
    pop
  then
;

( Get the game number from the player )
: GetGame ( -- s )
  me @ PLAYERPROP "PlayingIn" strcat getpropstr
;
 
( Turn a string into a player prop string and dbref )
: MakePlayerProp ( p# s -- # s)
  PLAYERPROP swap strcat
;
 
( Get a prop string from the player )
: GetPlayerStr ( p# s -- s )
  over #0 dbcmp if pop pop "" exit then
  MakePlayerProp getpropstr
;
 
( Get a value from the player )
: GetPlayerVal ( p# s -- n )
  over #0 dbcmp if pop pop 0 exit then
  MakePlayerProp getpropval
;
 
( Turn a string into a game prop string and dbref for the current player's game )
: MakeGameProp ( s -- # s )
  GetGame PLAYERPROP swap strcat "/" strcat swap strcat
  GLOBALOBJECT swap
;
 
( Get a string from the game )
: GetGameStr ( s -- s )
  MakeGameProp getpropstr
;
 
( Get a value from the game )
: GetGameVal ( s -- n )
  MakeGameProp getpropval
;
 
( Get a specific game prop )
: MakeGameNProp ( s s -- # s )
  PLAYERPROP rot strcat "/" strcat swap strcat
  GLOBALOBJECT swap
;
 
( Get a specific game string )
: GetGameNStr ( s s -- s )
  MakeGameNProp getpropstr
;
 
( Get a specific game value  )
: GetGameNVal ( s s -- n )
  MakeGameNProp getpropval
;

 
( Send a message to the requested player )
: TellOne ( # s -- )
  GAMEPREFIX swap strcat notify
;
 
( Send a message to current player )
: TellMe ( s -- )
  me @ swap TellOne
;

( pre-emptively acquire a run lock on the game )
( will block until the game is available )
( no action if you are not in a game )
( should it timeout?? )
: lockgame ( -- )
    ( no lock required if not in a game )
    me @ "PlayingIn" GetPlayerStr "" strcmp if
	  1 begin dup while
    
  	    ( disable multitasking - only one script in this at a time )
	    preempt
	
	    ( try to get the game lock variable )
	    "GameLock" GetGameVal 0 = if
	      (we got it, set the value and we are done)
	      "GameLock" MakeGameProp "" 1 addprop
	      pop 0
	    else 
	      1 +
	      dup 500000 > if
	        (it has been too long)
	        "** Removing stale lock - continuing..." tellme
	        break
	      then
        then
        ( give other script a chance to run )
        foreground
      repeat
      pop
    then
;

( release the game run lock - no action if you )
( are not in a game )
: unlockgame ( -- )
  ( no lock required if not in a game )
  me @ "PlayingIn" GetPlayerStr "" strcmp if
    preempt
    "GameLock" MakeGameProp "" 0 addprop
    foreground
  then
;

( ------------------- )

( Used for the Chance and Comm Chest, don't change this )
$def JAILFREECARD "G"
 
( Extract a numbered value from a list - 1-based )
( Note: debug is spammy as hell and disabled in this function )
: GetVal ( s n -- s )
  ( disable debug )
  prog "D" flag? tmpdebug !
  prog "!D" set
  ( --- )

  dup 0 > not if 
    pop pop "" 
    ( re-enable debug )
    tmpdebug @ if
      prog "D" set
    then
    ( --- )
    exit 
  then
  tmpstr !
  " " explode
  dup tmpstr @ < if
    begin dup while swap pop 1 - repeat pop "" 
    ( re-enable debug )
    tmpdebug @ if
      prog "D" set
    then
    ( --- )
	exit 
  then
  
  tmpstr @ 1 + pick tmpstr !
  
  begin dup while swap pop 1 - repeat pop
 
  tmpstr @

  ( re-enable debug )
  tmpdebug @ if
    prog "D" set
  then
  ( --- )
;
  
 
( Retrieve the name of a square - does not parse '~' )
: GetName ( n -- s )
  SPACES swap GetVal
  " " "_" subst   ( _ becomes a real space )
;
 
( Retrieve the full name of a square )
: GetFullName ( n -- s )
  GetName
  " " "~" subst   ( ~ becomes real space )
;
 
( Retrieve the first name of a square )
: GetFirstName ( n -- s )
  GetName
  dup " " instr dup if 1 - strcut pop else pop then
  " " "~" subst   ( ~ becomes real space )
;
 
( Retrieve the last name of a square )
: GetLastName ( n -- s )
  GetName
  dup " " instr dup if strcut swap pop else pop pop "" then
  " " "~" subst   ( ~ becomes real space )
;
 
( Retrieves the group number for a property )
: GetGroup ( n -- s )
  GROUPS swap GetVal
;
 
( Retrieves the color string for a property )
: GetColor ( n -- s )
  GetGroup dup "x" strcmp not if pop "^normal^" exit then
  atoi 1 + COLORS swap GetVal
;
 
( Retrieve the type of square - return free parking 'H' when invalid )
: GetType ( n -- s )
  TYPES swap GetVal dup "" strcmp not if pop "H" exit then
;
 
( Retrieves the rent0 for a property )
: GetRent0 ( n -- n )
  RENT0 swap GetVal dup "x" strcmp not if pop 0 exit then
  atoi
;
( Retrieves the rent1 for a property )
: GetRent1 ( n -- n )
  RENT1 swap GetVal dup "x" strcmp not if pop 0 exit then
  atoi
;
( Retrieves the rent2 for a property )
: GetRent2 ( n -- n )
  RENT2 swap GetVal dup "x" strcmp not if pop 0 exit then
  atoi
;
( Retrieves the rent3 for a property )
: GetRent3 ( n -- n )
  RENT3 swap GetVal dup "x" strcmp not if pop 0 exit then
  atoi
;
( Retrieves the rent4 for a property )
: GetRent4 ( n -- n )
  RENT4 swap GetVal dup "x" strcmp not if pop 0 exit then
  atoi
;
( Retrieves the rent hotel for a property )
: GetRentH ( n -- n )
  RENTH swap GetVal dup "x" strcmp not if pop 0 exit then
  atoi
;
    
( Retrieves the mortgage value for a property )
: GetMort ( n -- n )
  MORTGAGE swap GetVal dup "x" strcmp not if pop 0 exit then
  atoi
;
 
( Retrieves the housing cost for a property )
: GetHouse ( n -- s )
  GetGroup dup "x" strcmp not if pop 0 exit then
  atoi 1 + HOUSE swap GetVal atoi
;
 
( Retrieves the purchase cost for a property )
: GetPrice ( n -- n )
  PURCHASE swap GetVal dup "x" strcmp not if pop 0 exit then
  atoi
;
 
( Update the game's access timestamp - game number as a string )
: UpdateTimestamp ( s -- )
  GLOBALOBJECT PLAYERPROP rot strcat "/LastTurn" strcat "" systime addprop
;
 
( Get the owner of a property )
: GetOwner ( n -- dbref )
  intostr "Property/" swap strcat GetGameVal dbref
;
 
( Get number of houses - or hotel, or mortgage - on a property )
: GetHouseCount ( n -- n )
  dup GetOwner
  swap "Property/" swap intostr strcat GetPlayerVal
  1 -
;
 
( Send a string to all players and watchers: )
( - Ensure they are connected )
( - Remove from the list watchers who disconnect or leave the room )
: tellplayers ( s -- )
  ( First tell the game players )
  "Players" MakeGameProp
  REF-allrefs
  begin dup while
    dup 2 + pick rot swap tellone
    1 -
  repeat
  pop
 
  ( Now tell the watchers. Any watcher who is asleep or in another room will be removed )
  ( They are also removed if they are playing a game! )
  "Watchers" MakeGameProp
  REF-allrefs
  begin dup while
    over dup dup awake? swap location loc @ dbcmp and not swap "PlayingIn" GetPlayerStr "" strcmp or if
      ( remove this watcher )
      swap "Watchers" MakeGameProp rot REF-delete
    else
      ( tell this watcher )
      dup 2 + pick rot swap tellone
    then
    1 -
  repeat
  pop
  pop
;
 
( Add money to Free Parking )
: AddFreeParking ( amount )
  "FreeParking" GetGameVal swap +
  "FreeParking" MakeGameProp "" 4 rotate addprop
;
 
( Set up props for 'me' being in jail )
: GoToJail ( -- )
  me @ "InJail" MakePlayerProp "" 1 addprop
  me @ "Location" MakePlayerProp "" 11 addprop
  ( Doubles stop counting when you go to jail )
  "DoublesCount" MakeGameProp "" 0 addprop
;
 
( Get the actual rent on a property - NOTE: Not Utility or Railroad )
( Also note: Must be owned! )
: GetActualRent ( n -- n )
  dup GetHouseCount                                     ( n c )
  dup 0 = if                                            ( n c )
    pop dup GetRent0                                    ( n r0 )
    over GetGroup                                       ( n r0 gr )
    "Groups/" swap strcat rot GetOwner swap GetPlayerVal
    0 = if
      "- All properties in group are owned - rent is doubled!" tellplayers
      2 *
    then
  else
    dup 1 = if pop GetRent1 else
      dup 2 = if pop GetRent2 else
        dup 3 = if pop GetRent3 else
          dup 4 = if pop GetRent4 else
            dup 5 = if pop GetRentH else
              pop pop 0 exit
            then
          then
        then
      then
    then
  then
;
 
( Get the actual rent on a Railroad only )
: GetRailroadRent ( n -- n )
  ( Check unowned or mortgaged )
  dup GetHouseCount dup -1 = swap 6 = or if pop 0 exit then
 
  ( Railroads are group 1, and there are 4, so we use that stat )
  GetOwner dup "Groups/1" GetPlayerVal 

  ( Check any are owned )
  dup dup 0 < swap 3 > or if pop 0 exit then
 
  ( If a penalty is set, it is twice the regular rent )
  dup 0 = if pop name " owns all four railroads! Rent is $" strcat 200 then
  dup 1 = if pop name " owns three railroads. Rent is $" strcat 100 then
  dup 2 = if pop name " owns two railroads. Rent is $" strcat 50 then
  dup 3 = if pop name " owns only one railroad. Rent is $" strcat 25 then
  ( Had to be one of the above, so the value is now popped )
  RentPenalty @ if 2 * then
  swap over intostr strcat "." strcat tellplayers
;
 
( Get the actual rent on a Utility )
: GetUtilityRent ( n -- n )
  ( Check unowned or mortgaged )
  dup GetHouseCount dup -1 = swap 6 = or if pop 0 exit then

  ( If a penalty is set, it is a new roll, and 10 times the amount thrown )
  RentPenalty @ if    ( not necessary to reset because it's only valid for one command )
    pop
    ( roll two dice )
    random 6 % 1 +
    random 6 % 1 +
	me @ name " rolls " strcat over intostr strcat " and " strcat 3 pick intostr strcat "." strcat tellplayers
	+ 10 *
	exit
  then
 
  ( Utilities are group 4, and there are 2 of them )
  GetOwner dup "Groups/4" GetPlayerVal 
  dup 0 = if pop name " owns both utilities - rent is 10 times roll!" strcat tellplayers thisroll @ 10 * exit then
  dup 1 = if pop name " owns one utility, rent is 4 times roll." strcat tellplayers thisroll @ 4 * exit then
  pop pop 0
;
 
( Gets a player's current worth and stats )
: GetWorth ( player# - Properties Mortgages Groups Houses Hotels Cash Total )
  ( disable debug )
  prog "D" flag? tmpdebug3 !
  prog "!D" set
  ( --- )


  0 0 0 0 0 0 0
 
  ( Properties )
  1 begin    ( # P M G H H C T n )
    "Property/" over intostr strcat
    10 pick swap GetPlayerVal
    dup 0 = not if
      ( Property is owned )
      over GetPrice           ( # P M G H H C T n h $ )
	  over 7 = if 2 / then    ( mortgaged property = 1/2 value )
      4 rotate + -3 rotate    ( # P M G H H C T n h )
      9 rotate 1 + -9 rotate  ( # P M G H H C T n h )
      dup 7 = if
        ( Property is mortgaged )
        8 rotate 1 + -8 rotate
      else
        dup 6 = if
          ( Property has a hotel )
          over GetHouse 5 * 4 rotate + -3 rotate
          5 rotate 1 + -5 rotate
        else
          ( Property may have houses )
          1 -
          dup 7 rotate + -6 rotate
          dup 3 pick GetHouse * 4 rotate + -3 rotate
        then
      then
    then
    pop
 
    1 + dup 41 < while
  repeat
  pop
 
  ( Groups - stat only )
  0 begin   ( # P M G H H C T n )
    "Groups/" over intostr strcat
    10 pick swap GetPlayerVal
    0 = if  ( # P M G H H C T n )
      6 rotate 1 + -6 rotate
    then
 
    1 + dup 10 < while
  repeat
  pop
 
  ( Cash )
  "Cash" 9 pick swap GetPlayerVal  ( # P M G H H C T $ )
  dup 4 rotate + -3 rotate
  +                                ( # P M G H H C T )
  8 rotate pop                     ( P M G H H C T )

  ( re-enable debug )
  tmpdebug3 @ if
    prog "D" set
  then
  ( --- )
;
 
( Remove a prop - wrapper for remove_prop that ignores the / at the end )
: propremove ( # s -- )
  dup strlen 1 - strcut
  dup "/" strcmp not if
    pop
  else
    strcat
  then
 
  remove_prop
;
 
( Return a string with spaces between each character )
: spaceit ( s -- s )
  dup strlen                       ( s l )
  begin 1 - dup while              ( s l )
    dup -3 rotate strcut " " swap strcat    
    strcat
    swap
  repeat
  pop
;
 
( Draw bottom line to show who owns a square, if anyone )
: ShowSquareInfo ( n -- )
  me @ "PlayingIn" GetPlayerStr "" strcmp not if
    ( Not playing a game, just draw an emtpy base )
    pop "^white^|_____________________________|" tellme
    exit
  then
 
  GetOwner dup #0 dbcmp if 
  ( Not owned, just draw an emtpy base )
  pop  
  "^white^|_____________________________|" tellme
  exit
  then 
 
  name "^normal^Owned by: ^yellow^" swap strcat "^white^" strcat 29 STRcenter 
  "_" " " subst "|" strcat "^white^|" swap strcat tellme
;
 
( Print out a deed for a square )
: PrintADeed ( n -- )
  TYPES over GetVal dup "" strcmp not if
    "* Square out of range" tellme pop pop exit
  then
  
  over GetHouseCount 
  dup 6 = if
    ( property is mortgaged )
    pop pop
    "^white^_______________________________" tellme
    "^white^|                             |" tellme
    "^white^|" over GetFirstName toupper 29 STRcenter strcat "^white^|" strcat tellme
    "^white^|" over GetLastName dup "Ave" stringcmp not if pop "Avenue" then 29 STRcenter strcat "^white^|" strcat tellme
    "^white^|                             |" tellme
    "^white^|              -              |" tellme
    "^white^|                             |" tellme
    "^white^|          MORTGAGED          |" tellme
    "^white^|           FOR $" over GetMort intostr 3 STRLeft strcat "          |" strcat tellme
    "^white^|                             |" tellme
    "^white^|              -              |" tellme
    "^white^|                             |" tellme
    "^white^|   Card must be turned this  |" tellme
    "^white^|    side up if property is   |" tellme
    "^white^|          mortgaged.         |" tellme
    "^white^|                             |" tellme
    "^white^|                             |" tellme
    ShowSquareInfo
    exit
  then
  -3 rotate  ( housecount square type )
 
  dup "A" strcmp not if
    ( property )
    pop
    "^white^_______________________________" tellme
    "^white^|" over getcolor strcat "###########################" strcat over 10 < if "#" strcat then "^normal^" strcat over intostr strcat "^white^|" strcat tellme
    "^white^|" over getcolor strcat "###( ^white^" strcat over GetFullName 20 STRcenter strcat over getcolor strcat ")###^white^|" strcat tellme
    "^white^|" over getcolor strcat "#############################^white^|" strcat tellme
    "^white^|\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"|" tellme
    dup GetGroup "Groups/" swap strcat over getowner dup rot GetPlayerVal
    swap #0 dbcmp not swap 0 = and 3 pick 1 < and if
      "^white^|" 3 pick 0 = if "^green^" strcat then "          RENT" strcat over GetRent0 2 * intostr "$" swap strcat 4 STRright strcat ".          ^white^|" strcat tellme
      "^white^|^green^(double rent for color group)^white^|" tellme
    else
      "^white^|" 3 pick 0 = if "^green^" strcat then "          RENT" strcat over GetRent0 intostr "$" swap strcat 4 STRright strcat ".          ^white^|" strcat tellme
      "^white^|                             |" tellme
    then

    "^white^|" 3 pick 1 = if "^green^" strcat then "  With 1 House       $" strcat over GetRent1 intostr 4 STRright strcat ".  ^white^|" strcat tellme
    "^white^|" 3 pick 2 = if "^green^" strcat then "  With 2 Houses      $" strcat over GetRent2 intostr 4 STRright strcat ".  ^white^|" strcat tellme
    "^white^|" 3 pick 3 = if "^green^" strcat then "  With 3 Houses      $" strcat over GetRent3 intostr 4 STRright strcat ".  ^white^|" strcat tellme
    "^white^|" 3 pick 4 = if "^green^" strcat then "  With 4 Houses      $" strcat over GetRent4 intostr 4 STRright strcat ".  ^white^|" strcat tellme
    "^white^|" 3 pick 5 = if "^green^" strcat then "      With HOTEL" strcat over GetRentH intostr "$" swap strcat 6 STRright strcat ".      ^white^|" strcat tellme
    "^white^|                             |" tellme
    "^white^|    Mortgage Value" over GetMort intostr "$" swap strcat 5 STRright strcat ".     |" strcat tellme
    "^white^|   Houses cost" over GetHouse intostr "$" swap strcat 5 STRright strcat ". each    |" strcat tellme
    "^white^| Hotels," over GetHouse intostr "$" swap strcat 5 STRright strcat ". plus 4 houses |" strcat tellme
    "^white^|                             |" tellme
    swap pop
    ShowSquareInfo
    exit
  then
 
  dup "D" strcmp not if
    ( railroad )
    pop
    ( We actually want the railroad owned count )
    over -1 = 3 pick 6 = or if 4
    else
      ( property is owned, get the count ) 
      ( Railroads are group 1, and there are 4, so we use that stat )
      dup GetOwner "Groups/1" GetPlayerVal
      ( 4, 3, 2, 1, or 0 )
    then
                ( HOUSCNT, SQ, OWNCNT )
    swap        ( HOUSCNT, OWNCNT, SQ )
 
    "^white^_______________________________" tellme
    "^white^|###########\"\"###\"\"\"\"#######" over 10 < if "#" strcat then "^normal^" strcat over intostr strcat "^white^|" strcat tellme
    "^white^|###########\\/###\\  /#########|" tellme
    "^white^|#########(        (##########|" tellme
    "^white^|#########/_/(_)#(_)##########|" tellme
    "^white^| --------------------------- |" tellme
    "^white^|" over GetFullName 29 STRcenter strcat "|" strcat tellme
    "^white^| --------------------------- |" tellme
    "^white^|                             |" tellme
    "^white^|" 3 pick 3 = if "^green^" strcat then " Rent                   $25. ^white^|" strcat tellme
    "^white^|" 3 pick 2 = if "^green^" strcat then " If 2 R.R.'s are owned   50. ^white^|" strcat tellme
    "^white^|" 3 pick 1 = if "^green^" strcat then " If 3  \"      \"    \"    100. ^white^|" strcat tellme
    "^white^|" 3 pick 0 = if "^green^" strcat then " If 4  \"      \"    \"    200. ^white^|" strcat tellme
    "^white^|                             |" tellme
    "^white^| Mortgage Value        $100. |" tellme
    "^white^|                             |" tellme
    "^white^|                             |" tellme
    ShowSquareInfo
    pop pop
    exit
  then
 
  dup "G" strcmp not if
    ( utility )
    pop
    ( We actually want the utility owned count )
    over -1 = 3 pick 6 = or if 2
    else
      ( property is owned, get the count ) 
      ( Utilities are group 4, and there are 2, so we use that stat )
      dup GetOwner "Groups/4" GetPlayerVal
      ( 1, or 0 )
    then
    swap
    ( only two utilties )
    dup 20 < if
      ( Electric company )
      "^white^_______________________________" tellme
      "^white^|             ,-,           " over 10 < if " " strcat then "^normal^" strcat over intostr strcat "^white^|" strcat tellme
      "^white^|            | V |            |" tellme
      "^white^|             \\|/             |" tellme
      "^white^|              W              |" tellme
      "^white^| --------------------------- |" tellme
      "^white^|" over GetFullName 29 STRcenter strcat "|" strcat tellme
    else
      "^white^_______________________________" tellme
      "^white^|                           " over 10 < if " " strcat then "^normal^" strcat over intostr strcat "^white^|" strcat tellme
      "^white^|             \"X\"             |" tellme
      "^white^|           (xxHxo,           |" tellme
      "^white^|                 \"           |" tellme
      "^white^| --------------------------- |" tellme
      "^white^|" over GetFullName 29 STRcenter strcat "|" strcat tellme
    then
    
    "^white^| --------------------------- |" tellme
    "^white^|" 3 pick 1 = if "^green^" strcat then "   If one \"Utility\" is owned ^white^|" strcat tellme
    "^white^|" 3 pick 1 = if "^green^" strcat then " rent  is  4   times  amount ^white^|" strcat tellme
    "^white^|" 3 pick 1 = if "^green^" strcat then " shown on dice.              ^white^|" strcat tellme
    "^white^|" 3 pick 0 = if "^green^" strcat then "   If both  \"Utilities\"  are ^white^|" strcat tellme
    "^white^|" 3 pick 0 = if "^green^" strcat then " owned  rent  is   10  times ^white^|" strcat tellme
    "^white^|" 3 pick 0 = if "^green^" strcat then " amount shown on dice.       ^white^|" strcat tellme
    "^white^|                             |" tellme
    "^white^| Mortgage Value         $75. |" tellme
    "^white^|                             |" tellme
    ShowSquareInfo
    pop pop
    exit
  then
  pop pop intostr "* Square was not recognized: " swap strcat tellme
;
 
( Appends a square to the strings for display )
: AddOneSquare ( 18 strings, top to bottom, # to add -- 18 strings)
  dup 40 > if 40 - then
  dup 1 < if 40 + then
  TYPES over GetVal dup "" strcmp not if
    pop pop exit
  then
  
  dup "A" strcmp not if                      ( 18 n A )
    ( property )
    pop                                                                      ( 18 n )
    swap "^white^___________________" strcat -19 rotate
    ( Decide which top picture to draw )
    dup getcolor TmpStr !  ( save color string )
    dup GetHouseCount
	dup 6 = if
	  pop  ( mortgaged )
      swap "^white^|" strcat TmpStr @ strcat "###############" strcat over 10 < if "#" strcat then "^normal^" strcat over intostr strcat "^white^|" strcat -19 rotate
      swap "^white^|" strcat TmpStr @ strcat "####^white^MORTGAGED" strcat TmpStr @ strcat "####^white^|" strcat -19 rotate
      swap "^white^|" strcat TmpStr @ strcat "#################^white^|" strcat -19 rotate
      swap "^white^|" strcat TmpStr @ strcat "#################^white^|" strcat -19 rotate
    else dup 5 = if
      pop  ( hotel )
      swap "^white^|" strcat TmpStr @ strcat "####^crimson^___###___" strcat TmpStr @ strcat "##" strcat over 10 < if "#" strcat then "^normal^" strcat over intostr strcat "^white^|" strcat -19 rotate
      swap "^white^|" strcat TmpStr @ strcat "###^crimson^/#########\\" strcat TmpStr @ strcat "###^white^|" strcat -19 rotate
      swap "^white^|" strcat TmpStr @ strcat "###^crimson^|# #Y\"Y# #|" strcat TmpStr @ strcat "###^white^|" strcat -19 rotate
      swap "^white^|" strcat TmpStr @ strcat "###^crimson^|###|_|###|" strcat TmpStr @ strcat "###^white^|" strcat -19 rotate
    else dup 4 = if
      pop
      swap "^white^|" strcat TmpStr @ strcat "#^forest^,," strcat TmpStr @ strcat "##^forest^,," strcat TmpStr @ strcat "###^forest^,," strcat TmpStr @ strcat "##^forest^," strcat over 10 < if "," strcat then "^normal^" strcat over intostr strcat "^white^|" strcat -19 rotate
      swap "^white^|" strcat TmpStr @ strcat "^forest^/##\\/##\\" strcat TmpStr @ strcat "#^forest^/##\\/##\\^white^|" strcat -19 rotate
      swap "^white^|" strcat TmpStr @ strcat "^forest^|##||##|" strcat TmpStr @ strcat "#^forest^|##||##|^white^|" strcat -19 rotate
      swap "^white^|" strcat TmpStr @ strcat "#################^white^|" strcat -19 rotate
    else dup 3 = if
      pop
      swap "^white^|" strcat TmpStr @ strcat "#^forest^,," strcat TmpStr @ strcat "##^forest^,," strcat TmpStr @ strcat "###^forest^,," strcat TmpStr @ strcat "###" strcat over 10 < if "#" strcat then "^normal^" strcat over intostr strcat "^white^|" strcat -19 rotate
      swap "^white^|" strcat TmpStr @ strcat "^forest^/##\\/##\\" strcat TmpStr @ strcat "#^forest^/##\\" strcat TmpStr @ strcat "####^white^|" strcat -19 rotate
      swap "^white^|" strcat TmpStr @ strcat "^forest^|##||##|" strcat TmpStr @ strcat "#^forest^|##|" strcat TmpStr @ strcat "####^white^|" strcat -19 rotate
      swap "^white^|" strcat TmpStr @ strcat "#################^white^|" strcat -19 rotate
    else dup 2 = if
      pop
      swap "^white^|" strcat TmpStr @ strcat "#^forest^,," strcat TmpStr @ strcat "##^forest^,," strcat TmpStr @ strcat "########" strcat over 10 < if "#" strcat then "^normal^" strcat over intostr strcat "^white^|" strcat -19 rotate
      swap "^white^|" strcat TmpStr @ strcat "^forest^/##\\/##\\" strcat TmpStr @ strcat "#########^white^|" strcat -19 rotate
      swap "^white^|" strcat TmpStr @ strcat "^forest^|##||##|" strcat TmpStr @ strcat "#########^white^|" strcat -19 rotate
      swap "^white^|" strcat TmpStr @ strcat "#################^white^|" strcat -19 rotate
    else dup 1 = if
      pop
      swap "^white^|" strcat TmpStr @ strcat "#^forest^,," strcat TmpStr @ strcat "############" strcat over 10 < if "#" strcat then "^normal^" strcat over intostr strcat "^white^|" strcat -19 rotate
      swap "^white^|" strcat TmpStr @ strcat "^forest^/##\\" strcat TmpStr @ strcat "#############^white^|" strcat -19 rotate
      swap "^white^|" strcat TmpStr @ strcat "^forest^|##|" strcat TmpStr @ strcat "#############^white^|" strcat -19 rotate
      swap "^white^|" strcat TmpStr @ strcat "#################^white^|" strcat -19 rotate
    else
      pop
      swap "^white^|" strcat TmpStr @ strcat "###############" strcat over 10 < if "#" strcat then "^normal^" strcat over intostr strcat "^white^|" strcat -19 rotate
      swap "^white^|" strcat TmpStr @ strcat "#################^white^|" strcat -19 rotate
      swap "^white^|" strcat TmpStr @ strcat "#################^white^|" strcat -19 rotate
      swap "^white^|" strcat TmpStr @ strcat "#################^white^|" strcat -19 rotate
    then then then then then then
 
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|" strcat over GetFirstName 17 STRcenter strcat "|" strcat -19 rotate
    swap "^white^|" strcat over GetLastName 17 STRcenter strcat "|" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
	( Check owner name )
	dup GetOwner dup #0 dbcmp if
	  pop
      swap "^white^|" strcat over getprice "Price $" swap intostr strcat 17 STRcenter strcat "|" strcat -19 rotate
	else
      rot "^white^|^gray^" strcat swap name 17 STRcenter strcat "^white^|" strcat -19 rotate
    then	  
    swap "^white^|_________________|" strcat -19 rotate
    pop
    exit
  then
 
  dup "B" strcmp not if
    ( community chest )
    pop
    swap "^white^___________________" strcat -19 rotate
    swap "^white^|               " strcat over 10 < if " " strcat then "^normal^" strcat over intostr strcat "^white^|" strcat -19 rotate
    swap "^white^|" strcat over GetFirstName toupper 17 STRcenter strcat "|" strcat -19 rotate
    swap "^white^|" strcat over GetLastName toupper 17 STRcenter strcat "|" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|       ^yellow^/~~--.._  ^white^|" strcat -19 rotate
    swap "^white^|     ^yellow^_/       // ^white^|" strcat -19 rotate
    swap "^white^| ^yellow^_.-~ ~~--.._//  ^white^|" strcat -19 rotate
    swap "^white^| ^yellow^|~~--.._.-~|`   ^white^|" strcat -19 rotate
    swap "^white^| ^yellow^|`~d)..|.-~|    ^white^|" strcat -19 rotate
    swap "^white^| ^yellow^~~--.._|.-~`    ^white^|" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|     FOLLOW      |" strcat -19 rotate
    swap "^white^|  INSTRUCTIONS   |" strcat -19 rotate
    swap "^white^|   ON TOP CARD   |" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|_________________|" strcat -19 rotate
    pop
    exit
  then
 
  dup "C" strcmp not if
    ( income tax )
    pop
    swap "^white^___________________" strcat -19 rotate
    swap "^white^|               " strcat over 10 < if " " strcat then "^normal^" strcat over intostr strcat "^white^|" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|" strcat over GetFirstName toupper spaceit 17 STRcenter strcat "|" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|" strcat over GetLastName toupper spaceit 17 STRcenter strcat "|" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|       <*>       |" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|     PAY 10%     |" strcat -19 rotate
    swap "^white^|       OR        |" strcat -19 rotate
    swap "^white^|      $200       |" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|_________________|" strcat -19 rotate
    pop
    exit
  then
 
  dup "D" strcmp not if
    ( railroad )
    pop
    swap "^white^___________________" strcat -19 rotate
    dup GetHouseCount
	6 = if
	  ( mortgaged )
	  swap "^white^|    MORTGAGED  "
	else
      swap "^white^|               " 
	then
	strcat over 10 < if " " strcat then "^normal^" strcat over intostr strcat "^white^|" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|" strcat over GetFirstName 17 STRcenter strcat "|" strcat -19 rotate
    swap "^white^|" strcat over GetLastName 17 STRcenter strcat "|" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|     __    _____ |" strcat -19 rotate
    swap "^white^|    <##>  (####/ |" strcat -19 rotate
    swap "^white^|    _\\/____\\##/  |" strcat -19 rotate
    swap "^white^|   (#########(   |" strcat -19 rotate
    swap "^white^|   ,Y#########.  |" strcat -19 rotate
    swap "^white^|  d#P(##) (##)   |" strcat -19 rotate
    swap "^white^| ```  ``   ``    |" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
	( Check owner name )
	dup GetOwner dup #0 dbcmp if
	  pop
      swap "^white^|" strcat over getprice "Price $" swap intostr strcat 17 STRcenter strcat "|" strcat -19 rotate
	else
      rot "^white^|^gray^" strcat swap name 17 STRcenter strcat "^white^|" strcat -19 rotate
    then	  
    swap "^white^|_________________|" strcat -19 rotate
    pop
    exit
  then
 
  dup "E" strcmp not if
    ( chance )
    pop
    swap "^white^___________________" strcat -19 rotate
    swap "^white^|               " strcat over 10 < if " " strcat then "^normal^" strcat over intostr strcat "^white^|" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|" strcat over GetFullName toupper 17 STRcenter strcat "|" strcat -19 rotate
    swap "^white^|       ^purple^__        ^white^|" strcat -19 rotate
    swap "^white^|    ^purple^,d####b,     ^white^|" strcat -19 rotate
    swap "^white^|   ^purple^|P`    `Y|    ^white^|" strcat -19 rotate
    swap "^white^|   ^purple^|b      d|    ^white^|" strcat -19 rotate
    swap "^white^|    ^purple^*`   ,dP`    ^white^|" strcat -19 rotate
    swap "^white^|       ^purple^,d#`      ^white^|" strcat -19 rotate
    swap "^white^|      ^purple^d#`        ^white^|" strcat -19 rotate
    swap "^white^|     ^purple^(K__        ^white^|" strcat -19 rotate
    swap "^white^|      ^purple^\"#/        ^white^|" strcat -19 rotate
    swap "^white^|       ^purple^__        ^white^|" strcat -19 rotate
    swap "^white^|      ^purple^(##)       ^white^|" strcat -19 rotate
    swap "^white^|       ^purple^``        ^white^|" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|_________________|" strcat -19 rotate
    pop
    exit
  then
  dup "F" strcmp not if
    ( jail )
    pop
    swap "^white^_______________________________" strcat -19 rotate
    swap "^white^|     |^red^#####################" strcat over 10 < if "#" strcat then "^normal^" strcat over intostr strcat "^white^|" strcat -19 rotate
    swap "^white^|     |^red^########( ^white^I N ^red^)########^white^|" strcat -19 rotate
    swap "^white^|     |^red^#######################^white^|" strcat -19 rotate
    swap "^white^|  J  |^red^####^gloom^|~~|~~~|~~~|~~|^red^####^white^|" strcat -19 rotate
    swap "^white^|     |^red^####^gloom^|  |   |   |  |^red^####^white^|" strcat -19 rotate
    swap "^white^|     |^red^####^gloom^|  |   |   |  |^red^####^white^|" strcat -19 rotate
    swap "^white^|  U  |^red^####^gloom^|  |   |   |  |^red^####^white^|" strcat -19 rotate
    swap "^white^|     |^red^####^gloom^|  |   |   |  |^red^####^white^|" strcat -19 rotate
    swap "^white^|     |^red^####^gloom^|  |   |   |  |^red^####^white^|" strcat -19 rotate
    swap "^white^|  S  |^red^####^gloom^|  |   |   |  |^red^####^white^|" strcat -19 rotate
    swap "^white^|     |^red^####^gloom^|__|___|___|__|^red^####^white^|" strcat -19 rotate
    swap "^white^|     |^red^#######################^white^|" strcat -19 rotate
    swap "^white^|  T  |^red^######( ^white^J A I L ^red^)######^white^|" strcat -19 rotate
    swap "^white^|     |^red^#######################^white^|" strcat -19 rotate
    swap "^white^|     ~~~~~~~~~~~~~~~~~~~~~~~~|" strcat -19 rotate
    swap "^white^|         V I S I T I N G     |" strcat -19 rotate
    swap "^white^|_____________________________|" strcat -19 rotate
    pop
    exit
  then
  dup "G" strcmp not if
    ( utility )
    pop
    dup 20 < if
      ( electric company )
      swap "^white^___________________" strcat -19 rotate

      dup GetHouseCount
	  6 = if
	    ( mortgaged )
	    swap "^white^|    MORTGAGED  "
	  else
        swap "^white^|               " 
	  then
	  strcat over 10 < if " " strcat then "^normal^" strcat over intostr strcat "^white^|" strcat -19 rotate

      swap "^white^|                 |" strcat -19 rotate
      swap "^white^|" strcat over GetFirstName toupper 17 STRcenter strcat "|" strcat -19 rotate
      swap "^white^|" strcat over GetLastName toupper 17 STRcenter strcat "|" strcat -19 rotate
      swap "^white^|                 |" strcat -19 rotate
      swap "^white^|                 |" strcat -19 rotate
      swap "^white^| ^yellow^\"-  ,-~~-,  -\"  ^white^|" strcat -19 rotate
      swap "^white^| ^yellow^-- | ,  , | --  ^white^|" strcat -19 rotate
      swap "^white^| ^yellow^-- | \\\\// | --  ^white^|" strcat -19 rotate
      swap "^white^| ^yellow^-- \\  ||  / --  ^white^|" strcat -19 rotate
      swap "^white^| ^yellow^.-  \\ || /  -.  ^white^|" strcat -19 rotate
      swap "^white^|  ^yellow^.-  \\||/  -.   ^white^|" strcat -19 rotate
      swap "^white^|      ^gloom^|HH|       ^white^|" strcat -19 rotate
      swap "^white^|      ^gloom^|HH|       ^white^|" strcat -19 rotate
      swap "^white^|       ^gloom^``        ^white^|" strcat -19 rotate
  	  ( Check owner name )
	  dup GetOwner dup #0 dbcmp if
	    pop
        swap "^white^|" strcat over getprice "Price $" swap intostr strcat 17 STRcenter strcat "|" strcat -19 rotate
	  else
        rot "^white^|^gray^" strcat swap name 17 STRcenter strcat "^white^|" strcat -19 rotate
      then	  
      swap "^white^|_________________|" strcat -19 rotate
    else 
      ( Water works )
      swap "^white^___________________" strcat -19 rotate

      dup GetHouseCount
	  6 = if
	    ( mortgaged )
	    swap "^white^|    MORTGAGED  "
	  else
        swap "^white^|               " 
	  then
	  strcat over 10 < if " " strcat then "^normal^" strcat over intostr strcat "^white^|" strcat -19 rotate

      swap "^white^|" strcat over GetFirstName toupper 17 STRcenter strcat "|" strcat -19 rotate
      swap "^white^|" strcat over GetLastName toupper 17 STRcenter strcat "|" strcat -19 rotate
      swap "^white^|                 |" strcat -19 rotate
      swap "^white^|                 |" strcat -19 rotate
      swap "^white^|     O==#==O     |" strcat -19 rotate
      swap "^white^|  _     #        |" strcat -19 rotate
      swap "^white^| /#\\  ,d#b,      |" strcat -19 rotate
      swap "^white^| #/###|###|###o  |" strcat -19 rotate
      swap "^white^| #\\###|###|####b |" strcat -19 rotate
      swap "^white^| \\#/   '~'  `### |" strcat -19 rotate
      swap "^white^|             ### |" strcat -19 rotate
      swap "^white^|                 |" strcat -19 rotate
      swap "^white^|                 |" strcat -19 rotate
      swap "^white^|                 |" strcat -19 rotate
	  ( Check owner name )
	  dup GetOwner dup #0 dbcmp if
	    pop
        swap "^white^|" strcat over getprice "Price $" swap intostr strcat 17 STRcenter strcat "|" strcat -19 rotate
	  else
        rot "^white^|^gray^" strcat swap name 17 STRcenter strcat "^white^|" strcat -19 rotate
      then	  
      swap "^white^|_________________|" strcat -19 rotate
    then
    pop
    exit
  then
  dup "H" strcmp not if
    ( free parking )
    pop
    swap "^white^_______________________________" strcat -19 rotate
    swap "^white^|                           " strcat over 10 < if " " strcat then "^normal^" strcat over intostr strcat "^white^|" strcat -19 rotate
    swap "^white^|                             |" strcat -19 rotate
    swap "^white^|                             |" strcat -19 rotate
    swap "^white^|" strcat over GetFirstName toupper spaceit 29 STRcenter strcat "|" strcat -19 rotate
    swap "^white^|                             |" strcat -19 rotate
    swap "^white^|          ^red^,od###bo,          ^white^|" strcat -19 rotate
    swap "^white^|         ^red^(##^white^|###|^red^##)         ^white^|" strcat -19 rotate
    swap "^white^|          ^red^Y#######Y          ^white^|" strcat -19 rotate
    swap "^white^|           ^red^Y#^white^,-,^red^#Y           ^white^|" strcat -19 rotate
    swap "^white^|         ^red^d##^white^(#o#)^red^##b         ^white^|" strcat -19 rotate
    swap "^white^|         ^red^####^white^\"-\"^red^####         ^white^|" strcat -19 rotate
    swap "^white^|          U  ^red^`\"`  ^white^U          |" strcat -19 rotate
    swap "^white^|                             |" strcat -19 rotate
    swap "^white^|" strcat over GetLastName toupper spaceit 29 STRcenter strcat "|" strcat -19 rotate
    swap "^white^|                             |" strcat -19 rotate
    swap "^white^|                             |" strcat -19 rotate
    swap "^white^|_____________________________|" strcat -19 rotate
    pop
    exit
  then
  dup "I" strcmp not if
    ( Go To Jail )
    pop
    swap "^white^_______________________________" strcat -19 rotate
    swap "^white^|                           " strcat over 10 < if " " strcat then "^normal^" strcat over intostr strcat "^white^|" strcat -19 rotate
    swap "^white^|" strcat over GetFirstName toupper spaceit 29 STRcenter strcat "|" strcat -19 rotate
    swap "^white^|                             |" strcat -19 rotate
    swap "^white^|             ^blue^_,_             ^white^|" strcat -19 rotate
    swap "^white^|        ^blue^-**<###/      ^white^.      |" strcat -19 rotate
    swap "^white^|         )   r.\\     //      |" strcat -19 rotate
    swap "^white^|        (     .-'   /'--.    |" strcat -19 rotate
    swap "^white^|         \\     )=o |  ``:    |" strcat -19 rotate
    swap "^white^|        ^blue^.o^white^\\   /` ^blue^,db,^white^J``     |" strcat -19 rotate
    swap "^white^|        ^blue^_\\#^white^\\_ \\^blue^,d####P       ^white^|" strcat -19 rotate
    swap "^white^|       ^blue^/##\\##`d####P         ^white^|" strcat -19 rotate
    swap "^white^|       ^blue^##########P           ^white^|" strcat -19 rotate
    swap "^white^|       ^blue^########P             ^white^|" strcat -19 rotate
    swap "^white^|                             |" strcat -19 rotate
    swap "^white^|" strcat over GetLastName toupper spaceit 29 STRcenter strcat "|" strcat -19 rotate
    swap "^white^|                             |" strcat -19 rotate
    swap "^white^|_____________________________|" strcat -19 rotate
    pop
    exit
  then
  dup "J" strcmp not if
    ( luxury tax )
    pop
    swap "^white^___________________" strcat -19 rotate
    swap "^white^|               " strcat over 10 < if " " strcat then "^normal^" strcat over intostr strcat "^white^|" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|" strcat over GetFirstName toupper spaceit 17 STRcenter strcat "|" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|" strcat over GetLastName toupper spaceit 17 STRcenter strcat "|" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|      \\ | /      |" strcat -19 rotate
    swap "^white^|    ^yellow^_,p^white^[x]^yellow^q,_    ^white^|" strcat -19 rotate
    swap "^white^|   ^yellow^({`     `})   ^white^|" strcat -19 rotate
    swap "^white^|    ^yellow^`~Y###P~`    ^white^|" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|                 |" strcat -19 rotate
    swap "^white^|   PAY  $75.00   |" strcat -19 rotate
    swap "^white^|_________________|" strcat -19 rotate
    pop
    exit
  then
  dup "K" strcmp not if
    ( Go )
    pop
    swap "^white^_______________________________" strcat -19 rotate
    swap "^white^|                           " strcat over 10 < if " " strcat then "^normal^" strcat over intostr strcat "^white^|" strcat -19 rotate
    swap "^white^|           COLLECT           |" strcat -19 rotate
    swap "^white^|       $200.00  SALARY       |" strcat -19 rotate
    swap "^white^|         AS YOU PASS         |" strcat -19 rotate
    swap "^white^|                             |" strcat -19 rotate
    swap "^white^|     ^red^########   ########     ^white^|" strcat -19 rotate
    swap "^white^|     ^red^##         ##    ##     ^white^|" strcat -19 rotate
    swap "^white^|     ^red^##         ##    ##     ^white^|" strcat -19 rotate
    swap "^white^|     ^red^## #####   ##    ##     ^white^|" strcat -19 rotate
    swap "^white^|     ^red^##    ##   ##    ##     ^white^|" strcat -19 rotate
    swap "^white^|     ^red^##    ##   ##    ##     ^white^|" strcat -19 rotate
    swap "^white^|     ^red^########   ########     ^white^|" strcat -19 rotate
    swap "^white^|   ^red^,*                 ,,,,,  ^white^|" strcat -19 rotate
    swap "^white^|  ^red^<#|####################<   ^white^|" strcat -19 rotate
    swap "^white^|   ^red^`*                 `````  ^white^|" strcat -19 rotate
    swap "^white^|                             |" strcat -19 rotate
    swap "^white^|_____________________________|" strcat -19 rotate
    pop
    exit
  then
  pop pop
;
 
( Cut the last character off 18 strings, adds '@' as a separator )
: TrimSquareEdge ( 18 strings -- 18 strings )
  dup strlen 1 - strcut pop "@" strcat -18 rotate
  dup strlen 1 - strcut pop "@" strcat -18 rotate
  dup strlen 1 - strcut pop "@" strcat -18 rotate
  dup strlen 1 - strcut pop "@" strcat -18 rotate
  dup strlen 1 - strcut pop "@" strcat -18 rotate
  dup strlen 1 - strcut pop "@" strcat -18 rotate
  dup strlen 1 - strcut pop "@" strcat -18 rotate
  dup strlen 1 - strcut pop "@" strcat -18 rotate
  dup strlen 1 - strcut pop "@" strcat -18 rotate
  dup strlen 1 - strcut pop "@" strcat -18 rotate
  dup strlen 1 - strcut pop "@" strcat -18 rotate
  dup strlen 1 - strcut pop "@" strcat -18 rotate
  dup strlen 1 - strcut pop "@" strcat -18 rotate
  dup strlen 1 - strcut pop "@" strcat -18 rotate
  dup strlen 1 - strcut pop "@" strcat -18 rotate
  dup strlen 1 - strcut pop "@" strcat -18 rotate
  dup strlen 1 - strcut pop "@" strcat -18 rotate
  dup strlen 1 - strcut pop "@" strcat -18 rotate
;
 
( Prepare and notify 1 line of the output )
: PrintOneLine ( str -- )
  "@" explode pop
  ansistrip dup strlen 10 - strcut swap pop "^gloom^" swap strcat  ( first one )
  rot ansistrip 10 strcut pop 1 strcut "^gloom^" swap strcat strcat ( last one - start 1 in char )
  -3 rotate swap rot strcat strcat 
  command @ "board" stringcmp if
    tellplayers
  else
    tellme
  then
;
 
( Draw a square and it's neighbors )
: DrawSquare ( n -- )
  ( disable debug )
  prog "D" flag? tmpdebug2 !
  prog "!D" set
  ( --- )

  ( prepare 18 strings for the output )
  "" "" "" "" "" "" "" "" ""
  "" "" "" "" "" "" "" "" ""
  19 pick
  1 + AddOneSquare
  TrimSquareEdge
  19 pick
  AddOneSquare
  TrimSquareEdge
  19 rotate
  1 - AddOneSquare
  
  ( Now chop it, shade it, and print it )
  PrintOneLine
  PrintOneLine
  PrintOneLine
  PrintOneLine
  PrintOneLine
  PrintOneLine
  PrintOneLine
  PrintOneLine
  PrintOneLine
  PrintOneLine
  PrintOneLine
  PrintOneLine
  PrintOneLine
  PrintOneLine
  PrintOneLine
  PrintOneLine
  PrintOneLine
  PrintOneLine

  ( re-enable debug )
  tmpdebug2 @ if
    prog "D" set
  then
  ( --- )
;

( returns, rather hackily, the number of players still in the game )
: getPlayerCount ( -- n )
  "Players" MakeGameProp REF-allrefs
  dup
  begin dup while
    rot pop
    1 - 
  repeat
  pop
;
 
( Indicate the next turn: )
( - Same player if doubles were rolled < prop is greater than 0 > )
( - Else next player in the queue
( - Verify that player is still connected. If not, notify others about 'drop' )
: doNextTurn ( -- )
  GetGame UpdateTimestamp

  "Turn" GetGameVal dbref

  ForceNextTurn @ not if
    dup "Cash" GetPlayerVal 0 < if
      dup name " has a negative balance, and must settle their finances to proceed." strcat tellplayers
	  dup "You may trade or mortgage properties to gain sufficient cash. If you can not," tellone
  	  dup "type 'retire' to give in." tellone
	  pop
      "Phase" MakeGameProp "" 3 addprop
    
	  exit
    then
  then

  "DoublesCount" GetGameVal
  0 > if
    ( Rolled doubles, same player goes again )
    dup name " rolled doubles, and gets to go again." strcat tellplayers
  else
    ( No doubles, next player )
    "Players" MakeGameProp rot REF-next
    dup #-1 dbcmp if
      pop "Players" MakeGameProp REF-first
    then
    "It is now " over name strcat "'s turn." strcat over "InJail" GetPlayerVal dup if 
      1 + 3 pick "InJail" MakePlayerProp "" 4 rotate addprop
      " ^red^(In Jail)" strcat 
    else 
      pop
    then
    tellplayers
    dup int "Turn" MakeGameProp "" 4 rotate addprop
  then
 
  "Phase" MakeGameProp "" 1 addprop
 
  dup awake? if
    dup "InJail" GetPlayerVal if
      dup "You may type 'bail' to pay $50 bail, 'roll' to try for doubles to escape" tellone 
      dup "JailFree" GetPlayerVal if
        "or 'card' to use a ^yellow^Get Out of Jail Free^normal^ card" tellone
      else
        pop
      then
    else
      "Type 'roll' to roll the dice." tellone
    then
  else
    name " is not connected!! You may wait, or 'drop' the player" strcat tellplayers
  then
;

( Deduct amount from player )
: DeductCash ( player# amountn -- ) 
  over "Cash" GetPlayerVal swap -
  swap "Cash" MakePlayerProp "" 4 rotate addprop
;
 
( Add amount to player )
: AddCash ( player# amountn -- )
  over "Cash" GetPlayerVal +
  swap "Cash" MakePlayerProp "" 4 rotate addprop
  
  ( check if player got out of debt )
  "Phase" GetGameVal 3 = if
	"Turn" GetGameVal dbref "Cash" GetPlayerVal 0 >= if
	  "+ " "Turn" GetGameVal dbref name strcat " is out of debt and the game continues!" strcat tellplayers
      doNextTurn 
    then
  then
;  
 
( Transfer cash from player to player )
: TransferCash ( from# to# amountn -- )
  3 pick name " pays $" strcat over intostr strcat " to " strcat 3 pick name strcat tellplayers
  rot over deductcash
  addcash
;
 
( Perform an 'install' in the current room: )
( - Set the room description with the help    )
: doinstall ( -- )
  ( - Create the actions needed to run the game )
  loc @ "new;join;leave;retire;start;roll;trade;untrade;accept;reject;purchase;pass;buy;sell;mortgage;unmortgage;scores;portfolio;trading;deed;board;status;drop;watch;game;test;bail;card;credits;feep"
  newexit dup
  prog setlink
  "Dark" set
  "- Actions created..." tellme
  ( Program requires LinkOk and Mucker Level 3. LinkOk is needed for Chance and Community Chest )
  ( recursive calls, and M3 is needed for the code that searches for and removes old games, and )
  ( the very high average instruction count.                                                    )
  prog "L" set
  "- Props set..." tellme
 
  loc @ "newdesc#" "" 30 addprop   ( number of lines )
  loc @ "newdesc#/1"  "MUFopoloy! 1.0 by Tursi, Graphics by Marjan (for flipsidemuck.org 9999)"       ansifix 0 addprop
  loc @ "newdesc#/2"  "-----------------------------------------------------------------------"       ansifix 0 addprop
  loc @ "newdesc#/3"  "Use these commands in this room to play:"                                      ansifix 0 addprop
  loc @ "newdesc#/4"  "^white^new [<x>]^normal^ (x > 0)        - start a new game, use 'new ?' to list sets" ansifix 0 addprop
  loc @ "newdesc#/5"  "^white^join <game#>^normal^             - join game number 'game'"             ansifix 0 addprop
  loc @ "newdesc#/6"  "^white^leave^normal^                    - leave a game you've joined"          ansifix 0 addprop
  loc @ "newdesc#/7"  "^white^start^normal^                    - start a game you created with new"   ansifix 0 addprop
  loc @ "newdesc#/8"  "^white^roll^normal^                     - roll the dice and take your turn"    ansifix 0 addprop
  loc @ "newdesc#/9"  "^white^purchase^normal^                 - purchase the property you've landed on" ansifix 0 addprop
  loc @ "newdesc#/10" "^white^pass^normal^                     - do not purchase the property you landed on" ansifix 0 addprop
  loc @ "newdesc#/11" "^white^bail^normal^                     - pay bail to get out of jail"         ansifix 0 addprop
  loc @ "newdesc#/12" "^white^card^normal^                     - use a Get Out of Jail, Free card"    ansifix 0 addprop
  loc @ "newdesc#/13" "^white^buy <property#>^normal^          - buy a house/hotel for 'property' (list ok)" ansifix 0 addprop
  loc @ "newdesc#/14" "^white^sell <property#>^normal^         - sell a house/hotel from 'property' (list ok)" ansifix 0 addprop
  loc @ "newdesc#/15" "^white^mortgage <property#>^normal^     - mortgage a property"                 ansifix 0 addprop
  loc @ "newdesc#/16" "^white^unmortgage <property#>^normal^   - unmortgage a propert"                ansifix 0 addprop
  loc @ "newdesc#/17" "^white^trade <name>=<trade>^normal^     - offer a trade to 'name' ('trade' for help)" ansifix 0 addprop
  loc @ "newdesc#/18" "^white^untrade <name>^normal^           - revoke a trade to 'name' before acceptance" ansifix 0 addprop
  loc @ "newdesc#/19" "^white^accept <name>^normal^            - accept a trade offer from 'name'"    ansifix 0 addprop
  loc @ "newdesc#/20" "^white^reject <name>^normal^            - reject a trade offer from 'name'"    ansifix 0 addprop
  loc @ "newdesc#/21" "^white^scores^normal^                   - see the current scores"              ansifix 0 addprop
  loc @ "newdesc#/22" "^white^portfolio^normal^                - see your current possessions"        ansifix 0 addprop
  loc @ "newdesc#/23" "^white^trading^normal^                  - list your open trades"               ansifix 0 addprop
  loc @ "newdesc#/24" "^white^deed <property#>^normal^         - view the deed for 'property'"        ansifix 0 addprop
  loc @ "newdesc#/25" "^white^board [<id#>]^normal^            - view board square for 'id#', or whole board" ansifix 0 addprop
  loc @ "newdesc#/26" "^white^status [<game#>]^normal^         - view property owners and locations"  ansifix 0 addprop
  loc @ "newdesc#/27" "^white^drop <name>^normal^              - drop the player 'name' if offline"   ansifix 0 addprop
  loc @ "newdesc#/28" "^white^watch <game#>^normal^            - just watch 'game'"                   ansifix 0 addprop
  loc @ "newdesc#/29" "^white^game <name/game#>^normal^        - see game number for 'name', or list 'game#'"  ansifix 0 addprop
  loc @ "newdesc#/30" "^white^retire^normal^                   - declare bankruptcy (but still watch)" ansifix 0 addprop
 
  loc @ "{eval:{list:newdesc}}" setdesc
  "- Room Description set." tellme
;
 
( Join a game <n>: )
( - Verify player is not already in a game )
( - Add player to the game )
( - Set up player variables )
( - Notify all )
: dojoin ( s -- )
  me @ "PlayingIn" GetPlayerStr dup "" strcmp if
    "* You are already playing in game " swap strcat ". Use 'leave' to quit that game." strcat tellme
    exit
  then 
  pop
  atoi dup 0 = if
    "* Please specify the game number to join. Use 'game <name>' to see which game someone else is in." tellme
    pop exit
  then
  intostr
  dup "Players" GetGameNStr "" strcmp not if
    "* Game " swap strcat " does not exist." strcat tellme
    exit
  then
  dup "Started" GetGameNStr "1" strcmp not if
    "* Game " over strcat " has already started. You may use 'watch " strcat swap strcat "' to watch it." strcat tellme
    exit
  then
 
  ( add to game )
  dup me @ "PlayingIn" MakePlayerProp rot 0 addprop
  "Players" MakeGameProp me @ REF-add
  dup UpdateTimestamp
 
  loc @ #-1 me @ name " has joined game number " strcat 4 rotate strcat GAMEPREFIX swap strcat ansifix notify_except
 
  ( initialize variables )
  me @ "/Location" MakePlayerProp "" 1 addprop
  me @ "/InJail"   MakePlayerProp "" 0 addprop
  me @ "/JailFree" MakePlayerProp "" 0 addprop
  me @ "/Cash"     MakePlayerProp "" STARTCASH addprop
  me @ "/Trades"   MakePlayerProp      propremove
  me @ "/Property" MakePlayerProp      propremove
  me @ "/Groups/0" MakePlayerProp "" 2 addprop
  me @ "/Groups/1" MakePlayerProp "" 4 addprop
  me @ "/Groups/2" MakePlayerProp "" 3 addprop
  me @ "/Groups/3" MakePlayerProp "" 3 addprop
  me @ "/Groups/4" MakePlayerProp "" 2 addprop
  me @ "/Groups/5" MakePlayerProp "" 3 addprop
  me @ "/Groups/6" MakePlayerProp "" 3 addprop
  me @ "/Groups/7" MakePlayerProp "" 3 addprop
  me @ "/Groups/8" MakePlayerProp "" 3 addprop
  me @ "/Groups/9" MakePlayerProp "" 2 addprop
;
 
( Helper for donew - Create a shuffled list of 16 cards in a string )
: GetShuffledDeck ( -- )
  "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P"
  50 begin dup while
    random 16 %
	random 16 %      ( 16vars cnt x1 x2 )
	over 4 + pick    ( 16vars cnt x1 x2 v1 )
	over 5 + pick    ( 16vars cnt x1 x2 v1 v2 )
	4 rotate 4 + put ( 16vars cnt x2 v1 )
	swap 2 + put     ( 16vars cnt )
	1 -
  repeat
  pop
  strcat strcat strcat strcat strcat strcat strcat strcat strcat 
  strcat strcat strcat strcat strcat strcat 
;

( Create a new game: )
( - Verify player is not already in a game )
( - Delete all games older than 24hrs )
( - Increment the 'nextgame' counter )
( - Initialize all the props )
( - Announce the player and game number to the room )
( - Add the player as the first player <can call join> )
: donew ( s -- )
  ( Check the argument )
  dup "?" strcmp not if
    pop
	"Available Games:" tellme
	"  0 - Original board (default, you don't need to enter '0')" tellme
	( list available sets )
	1 begin 
	  "Set" over intostr strcat loc @ swap GetPropStr
	  dup "" strcmp not if
	    pop break
	  then
	  pop "Name" over intostr strcat loc @ swap GetPropStr
	  dup "" strcmp not if
	    pop "Unnamed"
	  then
	  over intostr 3 strRIGHT " - " strcat swap strcat tellme
	  1 +
	repeat
	pop
	"Start a custom set with 'new <x>', where 'x' is the number." tellme
    exit
  then

  atoi dup 0 > if
    "Set" over intostr strcat loc @ swap GetPropStr
	dup "" strcmp not if
	  pop "* Set " over intostr strcat " does not exist!" strcat tellme
	  pop exit
	then
	pop
  then

  ( Check if player is already in a game )
  me @ "PlayingIn" GetPlayerStr dup "" strcmp if
    "* You are already playing in game " swap strcat ". Use 'leave' to quit that game." strcat tellme
    pop
    exit
  then 
  pop
 
  ( Check for games older than 24hrs )
  PLAYERPROP
  begin GLOBALOBJECT swap nextprop dup "" strcmp while   ( str )
    dup "/LastTurn" strcat GLOBALOBJECT swap getpropval  ( str val )
    dup 0 = not if                                       ( str val )
      systime 86400 - < if                               ( str )
        ( this game is older than 24 hrs )
        dup GLOBALOBJECT swap remove_prop                ( str )
      then
    else
      pop
    then
  repeat
  pop
 
  ( get and increment the nextgame counter )
  ( this has some small potential for race, so disable multitasking )
  preempt
    GLOBALOBJECT PLAYERPROP "NextGame" strcat getpropval
    dup 0 = if 1 + then          (disallow game 0)
    dup 1 + GLOBALOBJECT PLAYERPROP "NextGame" strcat "" 4 rotate addprop
  foreground
 
  intostr  ( the game number is more commonly used as a string )
  
  ( Ensure the branch is empty - Player hasn't joined yet so can't use MakeGameProp )
  dup "" MakeGameNProp propremove
  
  ( Since the branch doesn't exist, everything defaults to zero )
  ( So we only need to set the things that don't )
  dup "HousesLeft" MakeGameNProp "" STARTHOUSES addprop
  dup "HotelsLeft" MakeGameNProp "" STARTHOTELS addprop
  dup "FreeParking" MakeGameNProp "" STARTPARKING addprop
  dup "Set" MakeGameNProp "" 5 rotate addprop

  ( Chance and Community Chest - shuffle the decks )
  dup "CommChest" MakeGameNProp GetShuffledDeck 0 addprop
  dup "Chance" MakeGameNProp GetShuffledDeck 0 addprop
 
  "* " me @ name strcat " has created game number " strcat over strcat ". Use 'join " strcat
  over strcat "' to join!" strcat loc @ #-1 rot GAMEPREFIX swap strcat ansifix notify_except
  "* After all players have joined, use 'start' to begin the game." tellme
 
  ( Make a dummy entry in the players list so dojoin can see it exists )
  dup "Players" MakeGameNProp #0 REF-add
  dup dojoin
  ( Now the player has joined, so we CAN use MakeGameProp )
  "Players" MakeGameProp #0 REF-delete
 
  pop
;
 
( Start a game created with new: )
( - Prepare any additional game variables )
( - Randomly choose the first player )
( - Tell the player to start )
: dostart ( -- )
  ( Check if player is already in a game, and that he owns it )
  me @ "PlayingIn" GetPlayerStr dup "" strcmp not if
    "* You are not currently playing any game! Use 'new' or 'join' to create or join a game." tellme
    pop
    exit
  then 
  
  dup "Players" MakeGameNProp REF-first me @ dbcmp not if
    "* Only the player who created the game with 'new' may start it." tellme
    pop
    exit
  then
 
  dup "Started" GetGameNStr "1" strcmp not if
    "* Game " swap strcat " has already been started." tellme
    exit
  then
 
  "Welcome to..." tellplayers
  "  ^red^_________________________________________________________________" tellplayers
  "^red^.\"                                                                 \"." tellplayers
  "^red^|   #,     ,# #    # #####  ,x##x,  ####b,  ,x##x,  #     Y,   ,Y   |" tellplayers
  "^red^|   #Y,   ,Y# #    # #     d`    `b #    # d`    `b #      Y, ,Y    |" tellplayers
  "^red^|   # Y, ,Y # #    # ####  #      # ####P` #      # #       YvY     |" tellplayers
  "^red^|   #  Y,Y  # Y,  ,Y #     Y,_  _,Y #      Y,_  _,Y #       ,Y      |" tellplayers
  "^red^|   #   \"   #  \"##\"  #      `*##*`  #       `*##*   ###### .Y       |" tellplayers
  "^red^'.____________________________________________________________v1.0_." tellplayers
  " " tellplayers
   
  dup UpdateTimestamp
 
  ( Set up for 'roll' phase )
  "Phase" MakeGameProp "" 1 addprop
 
  ( Randomly choose the first player )
  "Players" MakeGameProp REF-allrefs dup random swap %
  begin dup while
    rot pop 1 - swap 1 - swap
  repeat
  pop 1 -
  begin dup while
    rot pop 1 -
  repeat
  pop
 
  dup name " will go first!" strcat tellplayers      ( game player )
  dup "Type 'roll' to roll the dice." tellone        ( game player )
 
  "Turn" MakeGameProp "" 4 rotate int addprop   
 
  ( Flag the game as started )
  "Started" MakeGameProp "1" 1 addprop
 
  pop
;
 
( Helper functions for the scores )
: scoreheader ( -- )
  " " tellme
  "Name           Properties Mortgaged Groups Houses Hotels   Cash    Worth" tellme
  "------------------------------------------------------------------------" tellme
;
 
: scoreline ( dbref -- )
  dup GetWorth   ( # Properties Mortgages Groups Houses Hotels Cash Total )
  intostr 9 STRright                                               ( total )
  swap intostr 6 STRright swap strcat                              ( cash )
  swap intostr 2 STRright "   " strcat swap strcat                 ( hotels )
  swap intostr 2 STRright "     " strcat swap strcat               ( houses )
  swap intostr 2 STRright "     " strcat swap strcat               ( groups )
  swap intostr 2 STRright "      " strcat swap strcat              ( Mortgages )
  swap intostr 2 STRright "         " strcat swap strcat           ( Properties )
  swap name 19 STRleft swap strcat                                 ( name )
  tellme
;
 
: scorefooter ( -- )
  "------------------------------------------------------------------------" tellme
;
 
( Display current scores <money and property summary> )
( Current game unless specified )
: doscores ( s -- )
  atoi dup 0 = if
    pop GetGame atoi dup 0 = if
      "* Use 'scores <game number>' to view a game you are not playing." tellme
      exit
    then
  then
 
  intostr 
  dup "Started" GetGameNStr "1" strcmp if
    "* Game " over strcat " has not been started." strcat tellme
    exit
  then
 
  "-- Game #" over strcat " --" strcat tellme
  ScoreHeader 
 
  dup "Players" MakeGameNProp REF-allrefs
  begin dup while
    swap
    ScoreLine
    1 -
  repeat
 
  ScoreFooter


  GetGame atoi 0 = not if
    "HousesLeft" GetGameVal
    "HotelsLeft" GetGameVal
    "Houses Available: " rot intostr strcat "       Hotels Available: " strcat swap intostr strcat
    tellme
    ScoreFooter
  then
 
  pop
;
 
( Handle landing on a square )
: HandleLanding ( -- )
  me @ "Location" GetPlayerVal
  dup DrawSquare
 
  ScoreHeader me @ ScoreLine ScoreFooter
 
  dup GetType
 
  ( Now, what do we do with it? )
  dup "A" strcmp not if  ( property )
    swap 
    dup GetOwner dup #0 dbcmp if
      pop "This property is not owned! Type 'purchase' to buy it from the bank, or 'pass' to skip." tellme
      me @ name " is deciding whether to purchase this property!" strcat tellplayers
      "Phase" MakeGameProp "" 2 addprop
    else
      "This property is owned by " over name strcat tellplayers
      ( don't charge rent to the owner! )
      over GetOwner me @ dbcmp not if
        over GetActualRent dup 0 = if
          "Property is mortgaged - no rent is due!" tellplayers
          pop pop
          DoNextTurn
        else
          me @ name " owes $" strcat over intostr strcat " to " strcat 3 pick name strcat " for rent!" strcat tellplayers
          me @ -3 rotate TransferCash
          DoNextTurn
        then
      else
        pop
        DoNextTurn
      then
    then
    swap
  then
 
  dup "B" strcmp not if  ( community chest )  ( square_num category )
    (CommunityChest - forward reference)
    prog "CommunityChest" call
    ( Do not call DoNextTurn here )
  then
 
  dup "C" strcmp not if  ( income tax )
    ( the rules say the player must decide before actually counting his assets whether )
    ( he will pay 10% or $200, but I believe everyone just considers that annoying.    )
    ( So, the program will work it out and pay the lowest amount automatically.        )
    me @ GetWorth 
    -7 rotate pop pop pop pop pop pop  ( we only want the total value )
    5 + 10 /   ( Divide by 10, rounding up )
    dup 200 > if pop 200 then
    me @ name " owes $" strcat over intostr strcat " for income tax." strcat tellplayers
    me @ over DeductCash
    AddFreeParking
    DoNextTurn
  then
 
  dup "D" strcmp not if  ( Railroad )
    swap 
    dup GetOwner dup #0 dbcmp if
      pop "This property is not owned! Type 'purchase' to buy it from the bank, or 'pass' to skip." tellme
      me @ name " is deciding whether to purchase this property!" strcat tellplayers
      "Phase" MakeGameProp "" 2 addprop
    else
      "This property is owned by " over name strcat tellme
      ( don't charge rent to the owner! )
      over GetOwner me @ dbcmp not if
        over GetRailroadRent dup 0 = if
          "Property is mortgaged - no rent is due!" tellplayers
          pop pop
          DoNextTurn
        else
          me @ -3 rotate TransferCash
          DoNextTurn
        then
      else
        pop
        DoNextTurn
      then
    then
    swap
  then
 
  dup "E" strcmp not if  ( Chance )
    (Chance - forward reference)
    prog "Chance" call
    ( Do not call DoNextTurn here )
  then
 
  dup "F" strcmp not if  ( Jail )
    me @ "InJail" GetPlayerVal 1 = if
      me @ name " is IN JAIL!" strcat tellplayers
    then
    DoNextTurn
  then
 
  dup "G" strcmp not if  ( Utility )
    swap 
    dup GetOwner dup #0 dbcmp if
      pop "This property is not owned! Type 'purchase' to buy it from the bank, or 'pass' to skip." tellme
      me @ name " is deciding whether to purchase this property!" strcat tellplayers
      "Phase" MakeGameProp "" 2 addprop
    else
      "This property is owned by " over name strcat tellme
      ( don't charge rent to the owner! )
      dup me @ dbcmp not if
        over GetUtilityRent dup 0 = if
          "Property is mortgaged - no rent is due!" tellplayers
          pop pop
          DoNextTurn
        else
          me @ name " owes $" strcat over intostr strcat " to " strcat 3 pick name strcat " for rent!" strcat tellplayers
          me @ -3 rotate TransferCash
          DoNextTurn
        then
      else
        pop
        DoNextTurn
      then
    then
    swap
  then
 
  dup "H" strcmp not if  ( Free Parking )
    "FreeParking" GetGameVal
    me @ name " gets $" strcat over intostr strcat " for Free Parking!" strcat tellplayers
    me @ swap addcash
    "FreeParking" MakeGameProp "" 0 addprop
    DoNextTurn
  then
 
  dup "I" strcmp not if  ( Go To Jail )
    GoToJail
    HandleLanding
    ( do not call DoNextTurn here! )
  then
 
  dup "J" strcmp not if  ( Luxury Tax )
    me @ name " owes $75 for Luxury Tax!" strcat tellplayers
    me @ 75 deductcash
    75 AddFreeParking
    DoNextTurn
  then
 
  dup "K" strcmp not if  ( Go )
    ( Already dealt with it )
    DoNextTurn
  then
 
  pop
  pop
;

( Helper for Chance and Community Chest - takes the top card, and moves it )
( to the bottom of the list, returning a copy for processing )
( NOTE: does *not* return the card if it's JAILFREECARD, get out of Jail free. Make )
( sure GOFJF is ALWAYS JAILFREECARD, and that it's properly tracked                 )
: GetTopCard ( s -- s )
  dup GetGameStr                                        ( p str )
  1 strcut over dup JAILFREECARD strcmp if strcat else pop then  ( p x str )
  rot MakeGameProp                                      ( x str db prop )
  rot 0 addprop                                         ( x )
;
 
( Do the community chest )
( Note: Must call DoNextTurn unless we call HandleLanding again )
: CommunityChest ( -- )
  "Community Chest (" me @ name strcat "): " strcat
  "CommChest" GetTopCard
 
  dup "A" strcmp not if
    swap
    "Grand Opera Opening - ^green^Collect $50^normal^ from every player for opening night seats." strcat tellplayers
    
    "Players" MakeGameProp
    REF-allrefs
    begin dup while
      swap dup me @ dbcmp if pop else
        me @ 50 transfercash
      then
      1 -
    repeat
    pop
    DoNextTurn
  then
 
  dup "B" strcmp not if
    swap
    "Income Tax Refund - ^green^Collect $20^normal^" strcat tellplayers
    me @ 20 addcash
    DoNextTurn
  then
 
  dup "C" strcmp not if
    swap
    "You inherit ^green^$100^normal^" strcat tellplayers
    me @ 100 addcash
    DoNextTurn
  then
 
  dup "D" strcmp not if
    swap
    "Go to Jail. Go directly to Jail. Do not pass Go. Go not collect $200." strcat tellplayers
    GoToJail
    HandleLanding ( do not call DoNextTurn )
  then
 
  dup "E" strcmp not if
    swap
    "Receive for services - ^green^$25^normal^" strcat tellplayers
    me @ 25 addcash
    DoNextTurn
  then
 
  dup "F" strcmp not if
    swap
    "XMas Fund Matures - ^green^Collect $100^normal^" strcat tellplayers
    me @ 100 addcash
    DoNextTurn
  then
 
  dup "G" strcmp not if
    swap
    "Get out of Jail, Free. This card may be kept until needed or sold." strcat tellplayers
    me @ "JailFree" GetPlayerVal 1 +
    me @ "JailFree" MakePlayerProp "" 4 rotate addprop
	me @ "CommJailFree" MakePlayerProp "" 1 addprop
    DoNextTurn
  then
 
  dup "H" strcmp not if
    swap
    "Life insurance matures - ^green^Collect $100^normal^" strcat tellplayers
    me @ 100 addcash
    DoNextTurn
  then
 
  dup "I" strcmp not if
    swap
    "Doctor's Fee - ^red^Pay $50^normal^" strcat tellplayers
    me @ 50 deductcash
    50 AddFreeParking
    DoNextTurn
  then
 
  dup "J" strcmp not if
    swap
    "You have won SECOND PRIZE in a Beauty Contest - ^green^Collect $10^normal^" strcat tellplayers
    me @ 10 addcash
    DoNextTurn
  then
 
  dup "K" strcmp not if
    swap
    "From sale of stock you get ^green^$45^normal^" strcat tellplayers
    me @ 45 addcash
    DoNextTurn
  then
 
  dup "L" strcmp not if
    swap
    "Pay hospital ^red^$100^normal^" strcat tellplayers
    me @ 100 deductcash
    100 AddFreeParking
    DoNextTurn
  then
 
  dup "M" strcmp not if
    swap
    "Advance to Go (^green^Collect $200^normal^)" strcat tellplayers
    me @ 200 addcash
    me @ "Location" MakePlayerProp "" 1 addprop
    HandleLanding  ( Do Not call DoNextTurn )
  then
 
  dup "N" strcmp not if
    swap
    "You are assessed for street repairs. ^red^$40^normal^ per house, ^red^$115^normal^ per hotel" strcat tellplayers
    0 1 Begin
      me @ "Property/" 3 pick intostr strcat GetPlayerVal
      dup 0 > over 7 < and if
        ( Property here )
        dup 6 = if
          ( Hotel )  ( total property count )
          pop swap 115 + swap
        else
          ( Houses 0-4 )
          1 - 40 * rot + swap
        then
      else
        pop
      then
 
      1 + dup 41 < while
    repeat
    pop
 
    "Total cost: ^red^$" over intostr strcat tellplayers
    me @ over deductcash
    AddFreeParking
    DoNextTurn
  then
 
  dup "O" strcmp not if
    swap
    "Pay school tax of ^red^$150^normal^" strcat tellplayers
    me @ 150 deductcash
    150 AddFreeParking
    DoNextTurn
  then
 
  dup "P" strcmp not if
    swap
    "Bank error in your favor - ^green^Collect $200^normal^" strcat tellplayers
    me @ 200 AddCash
    DoNextTurn
  then
 
  ( one of the above cases MUST be hit, or we'll crash later )
  pop
;
 
( Do the Chance )
( You must call DoNextTurn unless you call HandleLanding again )
: Chance ( -- )
  "Chance (" me @ name strcat "): " strcat
  "Chance" GetTopCard
 
  dup "A" strcmp not if
    swap
    "You have been elected Chairman of the board - Pay each player ^red^$50^normal^" strcat tellplayers
    
    "Players" MakeGameProp
    REF-allrefs
    begin dup while
      swap dup me @ dbcmp if pop else
        me @ swap 50 transfercash
      then
      1 -
    repeat
    pop
    DoNextTurn
  then
 
  dup "B" strcmp not if
    swap
    "Pay poor tax of ^red^$15^normal^" strcat tellplayers
    me @ 15 deductcash
    DoNextTurn
  then
 
  dup "C" strcmp not if
    swap
    "Your building and loan matures - ^green^Collect $150^normal^" strcat tellplayers
    me @ 150 addcash
    DoNextTurn
  then
 
  dup "D" strcmp not if
    swap
    "Go directly to Jail. Do not pass Go. Go not collect $200." strcat tellplayers
    GoToJail
    HandleLanding  ( Do not call DoNextTurn )
  then
 
  dup "E" strcmp not if
    swap
    "Bank pays you dividend of ^green^$50^normal^" strcat tellplayers
    me @ 50 addcash
    DoNextTurn
  then
 
  dup "F" strcmp not if
    swap
    "Advance to " 12 GetFullName strcat ". If you pass Go, Collect $200" strcat strcat tellplayers
    me @ "Location" GetPlayerVal 12 >= if
      me @ name " passes Go and ^green^collects $200^normal^!" strcat tellplayers
      me @ 200 addcash
    then
    me @ "Location" MakePlayerProp "" 12 addprop
    HandleLanding  ( Do not call DoNextTurn )
  then
 
  dup "G" strcmp not if
    swap
    "This card may be kept until needed or sold. Get out of Jail free." strcat tellplayers
    me @ "JailFree" GetPlayerVal 1 +
    me @ "JailFree" MakePlayerProp "" 4 rotate addprop
	me @ "ChanceJailFree" MakePlayerProp "" 1 addprop
    DoNextTurn
  then
 
  dup "H" strcmp not if
    swap
    "Advance token to nearest utility. If unowned, you may buy it from the bank. If owned, throw dice and pay owner a total of ten times the amount thrown." strcat tellplayers
    me @ "Location" GetPlayerVal dup 29 >= if
      pop
      me @ name " passes Go and ^green^collects $200^normal^!" strcat tellplayers
      me @ 200 addcash
      me @ "Location" MakePlayerProp "" 13 addprop
	  1 RentPenalty !
      HandleLanding
    else
      dup 13 >= if
        pop
        me @ "Location" MakePlayerProp "" 29 addprop
		1 RentPenalty !
        HandleLanding
      else
        pop
        me @ "Location" MakePlayerProp "" 13 addprop
		1 RentPenalty !
        HandleLanding
      then
    then
    ( Do not call DoNextTurn )
  then
 
  dup "I" strcmp not over "J" strcmp not or if
    swap
    "Advance token to the nearest Railroad and pay owner Twice the rental to which he is otherwise entitled. If Railroad is unowned, you may buy it from the Bank." strcat tellplayers
    me @ "Location" GetPlayerVal dup 36 >= if
      pop
      me @ name " passes Go and ^green^collects $200^normal^!" strcat tellplayers
      me @ 200 addcash
      me @ "Location" MakePlayerProp "" 6 addprop
      1 RentPenalty !
      HandleLanding
    else
      dup 26 >= if
        pop
        me @ "Location" MakePlayerProp "" 36 addprop
		1 RentPenalty !
        HandleLanding
      else
        dup 16 >= if
          pop
          me @ "Location" MakePlayerProp "" 26 addprop
  		  1 RentPenalty !
          HandleLanding
        else
          dup 6 >= if
            pop
            me @ "Location" MakePlayerProp "" 16 addprop
    		1 RentPenalty !
            HandleLanding
          else
            pop
            me @ "Location" MakePlayerProp "" 6 addprop
    		1 RentPenalty !
            HandleLanding
          then
        then
      then
    then
    ( Do not call DoNextTurn )
  then
 
  dup "K" strcmp not if
    swap
    "Advance to " 25 GetFullName strcat strcat tellplayers
    me @ "Location" GetPlayerVal 25 >= if
      me @ name " passes Go and ^green^collects $200^normal^!" strcat tellplayers
      me @ 200 addcash
    then
    me @ "Location" MakePlayerProp "" 25 addprop
    HandleLanding  ( Do not call DoNextTurn )
  then
 
  dup "L" strcmp not if
    swap
    "Take a walk on the " 40 GetFullName strcat " - Advance token to " strcat 40 GetFullName strcat strcat tellplayers
    me @ "Location" GetPlayerVal 40 >= if
      me @ name " passes Go and ^green^collects $200^normal^!" strcat tellplayers
      me @ 200 addcash
    then
    me @ "Location" MakePlayerProp "" 40 addprop
    HandleLanding  ( Do not call DoNextTurn )
  then
 
  dup "M" strcmp not if
    swap
    "Take a ride on the " 6 GetFullName dup " " instr dup if 1 - strcut pop else pop then strcat
    ". If you pass Go, collect $200" strcat strcat tellplayers
    me @ "Location" GetPlayerVal 6 >= if
      me @ name " passes Go and ^green^collects $200^normal^!" strcat tellplayers
      me @ 200 addcash
    then
    me @ "Location" MakePlayerProp "" 6 addprop
    HandleLanding  ( Do not call DoNextTurn )
  then
 
  dup "N" strcmp not if
    swap
    "Make general repairs on all your property. For each House, pay ^red^$25^normal^, for each Hotel ^red^$100^normal^" strcat tellplayers
    0 1 Begin
      me @ "Property/" 3 pick intostr strcat GetPlayerVal
      dup 0 > over 7 < and if
        ( Property here )
        dup 6 = if
          ( Hotel )  ( total property count )
          pop swap 100 + swap
        else
          ( Houses 0-4 )
          1 - 25 * rot + swap
        then
      else
        pop
      then
 
      1 + dup 41 < while
    repeat
    pop
 
    "Total cost: ^red^$" over intostr strcat tellplayers
    me @ over deductcash
    AddFreeParking
    DoNextTurn
  then
 
  dup "O" strcmp not if
    swap
    "Go back 3 spaces" strcat tellplayers
    me @ "Location" GetPlayerVal 3 -  ( There are no Chance squares that can push us back before GO )
    me @ "Location" MakePlayerProp "" 4 rotate addprop
    HandleLanding  ( Do not call DoNextTurn )
  then
 
  dup "P" strcmp not if
    swap
    "Advance to Go (^green^Collect $200^normal^)" strcat tellplayers
    me @ 200 AddCash
    me @ "Location" MakePlayerProp "" 1 addprop
    HandleLanding  ( Do not call DoNextTurn )
  then
 
  ( one of the above cases MUST be hit, or we'll crash later )
  pop
;
 
( Leave the current game: )
( - If game has started )
(   - Return properties to the bank )
(   - Increment aborts )
( - Reset game variables )
( - Reset player variables )
( - Set new game player, if applicable )
: leavegame ( dbref -- )
  localtmp !     (dbref)
  
  ( Check if player is already in a game )
  localtmp @ "PlayingIn" GetPlayerStr dup "" strcmp not if
    localtmp @ me @ dbcmp if
      "* You are not currently playing any game!" tellme
    else 
      "* " localtmp @ name strcat " is not playing any game!" strcat tellme
    then
    pop
    exit
  then 
  
  "Started" GetGameStr "1" strcmp if
    "Game " over strcat " has not been started yet." strcat tellme
    localtmp @ "PlayingIn" MakePlayerProp propremove
    "Players" MakeGameProp localtmp @ REF-delete
    localtmp @ name " has left game " strcat swap strcat loc @ #-1 rot GAMEPREFIX swap strcat ansifix notify_except
    exit
  then
 
  localtmp @ name " has left game " strcat over strcat loc @ #-1 rot GAMEPREFIX swap strcat ansifix notify_except
 
  1
  begin
    dup intostr "property/" swap strcat GetGameVal
    localtmp @ int = if
      "- Returning property #" over intostr strcat " (" strcat over GetFullName strcat ") to the bank" strcat tellplayers
      ( update house/hotel count! )
	  dup GetHouseCount
	  dup 5 = if pop "HotelsLeft" GetGameVal 1 + "HotelsLeft" MakeGameProp "" 4 rotate addprop 
	    else dup 6 = if pop 
		  else dup 0 = if pop 
		    else "HousesLeft" GetGameVal + "HousesLeft" MakeGameProp "" 4 rotate addprop
		  then
		then
	  then

      dup intostr "property/" swap strcat MakeGameProp propremove
    then
    1 + dup 41 < while
  repeat
  pop

  localtmp @ "Aborts" MakePlayerProp ""
  localtmp @ "Aborts" GetPlayerVal 1 +
  addprop

  ( force each player to reject trades in case there were any )
  "Players" MakeGameProp
  REF-allrefs
  begin dup while
    swap localtmp @                    ( .. cnt player# leaver# )
    over "Trades/" 3 pick intostr strcat ( .. cnt player# leaver# player# prop ) 
    MakePlayerProp propremove            ( .. cnt player# leaver# )  
    "* Removing pending trades from " swap name strcat tellone ( .. cnt )

    1 -
  repeat
  pop

  ( Remove any count of doubles )
  "DoublesCount" MakeGameProp "" 0 addprop
 
  ( Update the current turn )
  "Turn" GetGameVal dbref localtmp @ dbcmp if
    "Players" GetGameStr " " instring if  ( supress the DoNextTurn if we are the only player )
      "DoublesCount" MakeGameProp "" 0 addprop   ( disable doubles roll )
      1 ForceNextTurn !                          ( force next turn despite debt )
      DoNextTurn
    then
  then
 
  pop (uses up the game number )
 
  ( check if no other players left )
  getPlayerCount 2 = if
    "Players" MakeGameProp REF-first name
    " ^yellow^WINS^normal^ the GAME!!" strcat tellplayers
    "Phase" MakeGameProp "" 1 addprop
    "Players" MakeGameProp REF-first 
    "* All commands are valid, but type 'leave' when you are done with the game" tellone
  then

  "Players" MakeGameProp localtmp @ REF-delete
  localtmp @ "PlayingIn" MakePlayerProp propremove
;

( Leave the current game: )
( - If game has started )
(   - Return properties to the bank )
(   - Increment aborts )
( - Reset game variables )
( - Reset player variables )
( - Set new game player, if applicable )
: doleave ( -- )
  ( special case - need to unlock the game )
  unlockgame  
  me @ leavegame
;

( check for any pending trades )
( returns the number of pending trades )
: hasPendingTrades ( -- i )
  0 localtmp !
  me @ "Trades/" makeplayerprop swap pop
  begin me @ swap nextprop dup "" strcmp while           ( str )
    localtmp @ 1 + localtmp !
  repeat
  pop
  localtmp @
;
 
( Roll the dice, take a turn: )
( - Move player )
( - Process square )
( - Increment doubles prop if doubles were rolled, else reset it )
: doroll ( -- )
  ( Check that it's our turn )
  "Turn" GetGameVal dbref me @ dbcmp not if
    "* It's not your turn." tellme
    exit
  then
 
  "Phase" GetGameVal 
  dup 3 = if
    "* The game is waiting for you to get out of debt, or 'retire'." tellme
	pop 
	exit
  then
  1 = not if
    me @ "Location" GetPlayerVal DrawSquare
    "* The game is waiting for you to 'purchase' or 'pass' this property." tellme
    exit
  then
  
  hasPendingTrades if
    "* You have pending trades to resolve before you roll (use 'trading' to see)." tellme
    exit
  then
 
  ( roll two dice )
  random 6 % 1 +
  random 6 % 1 +
 
  me @ name " rolled " strcat 3 pick intostr strcat " and " strcat over intostr strcat
  " for a total of: " strcat 3 pick 3 pick + intostr strcat tellplayers
 
  ( Check for jail )
  me @ "InJail" GetPlayerVal dup if
    ( Did we get doubles? )
    -3 rotate
    over over = if
      ( Yes! We're free! )
      ( Doesn't count as doubles )
      "DoublesCount" MakeGameProp "" 0 addprop
      me @ name " escapes from Jail!" strcat tellplayers
      me @ "InJail" MakePlayerProp "" 0 addprop
      ( clean up, then Let it fall through to below )
      rot pop
    else
      ( nope, not doubles )
      pop pop
      me @ name " did not escape jail." strcat tellplayers
      ( check for limit )
      4 >= if
        ( Yep, pay the fine )
        me @ name " MUST pay the $50 fine and leave jail." strcat tellplayers
        me @ 50 deductcash
        me @ "InJail" MakePlayerProp "" 0 addprop
      then
      ( we're done either way, stack is clean )
      DoNextTurn
	  exit
    then
  else
    pop
 
    ( check for doubles )
    over over = if
      "DoublesCount" GetGameVal
      1 + dup 3 = if
        "Three doubles in a row!! " me @ name strcat " goes straight to Jail!" strcat tellplayers
        pop 
        GoToJail
        pop pop
        HandleLanding  ( this calls DoNextTurn for us )
        exit
      then
      "DoublesCount" MakeGameProp "" 4 rotate addprop
    else
      ( Not doubles )
      "DoublesCount" MakeGameProp "" 0 addprop
    then
  then
 
  + ( add the dice together )
  dup ThisRoll !
  begin dup while
    me @ "Location" GetPlayerVal 1 +
    dup 40 > if 
      pop 1 
      "..." over GetFullName strcat " ^green^(Collect $200)" strcat 
	  28 strLEFT " ^gloom^(" strcat over intostr 2 strRIGHT strcat ")" strcat
	  tellplayers
      me @ 200 AddCash
    else
      "..." over GetFullName strcat 28 strLEFT " ^gloom^(" strcat over intostr 2 strRIGHT strcat ")" strcat 
	  over GetOwner dup #0 dbcmp if
	    pop
	  else
	    name " - " swap strcat strcat
	  then
	  tellplayers
    then
    me @ "Location" MakePlayerProp "" 4 rotate addprop
    1 -
  repeat
 
  HandleLanding
;

( Check if a property can be traded )
( Verifies that the property is owned by the player, has no houses )
( and that no other properties in the color group have houses )
: isTradable ( p# n -- f )
  ( Does the player own it? )
  dup GetOwner
  3 pick dbcmp not if pop pop 0 exit then 

  ( Does the player own the whole color group? )
  dup GetGroup "Groups/" swap strcat 3 pick swap GetPlayerVal
  0 = not if pop pop 1 exit then  ( no! So no houses are possible. )

  ( Are there any houses on it? Values 0 <0 house> and 6 <mortgaged> are legal )
  dup GetHouseCount
  dup 0 = swap 6 = or not if pop pop 0 
   then

  ( What about the rest of the group? )
  dup GetGroup 1 begin        ( p# n group idx )
    dup GetGroup 3 pick strcmp not if
	  dup GetHouseCount
      dup 0 = swap 6 = or not if pop pop 0 exit then
	then
    1 +
    dup 40 > if break then
  repeat

  ( We give up, must be okay! )
  pop pop pop pop 
  1
;

( Remove a list on top of the stack, size 'n' )
: flushstack ( ... n - )
  begin
    dup not if break then
    swap pop
	1 -
  repeat
  pop
;

( Show to p1# the trade offered to him by p2# )
( Include instructions on accepting or rejecting it )
: ShowTrade ( p1# p2# - )
  "--- Trade request from " over name strcat " ---" strcat 3 pick swap TellOne

  "Offered                       Wanted" 3 pick swap TellOne
  "Trades/" over intostr strcat "/Offer" strcat 3 pick swap GetPlayerStr	( p1# p2# offer )
  "Trades/" 3 pick intostr strcat "/Wanted" strcat 4 pick swap GetPlayerStr	( p1# p2# offer wanted )
  1
  begin
    3 pick over GetVal					( p1# p2# offer wanted index o1 )
	dup "" strcmp if
	  dup "$" 1 strncmp if
	    ( Property, convert to name )
  	    2 STRleft dup atoi dup GetColor swap dup GetHouseCount 6 = if "^gloom^(M) " else "" then swap
  	    GetFullName rot swap strcat strcat "^normal^" strcat swap " - " strcat swap strcat
  	  then
	then
	3 pick 3 pick GetVal				( p1# p2# offer wanted index o1 o2 )
	dup "" strcmp if
	  dup "$" 1 strncmp if
	    ( Property, convert to name )
  	    2 STRleft dup atoi dup GetColor swap dup GetHouseCount 6 = if "^gloom^(M) " else "" then swap
  	    GetFullName rot swap strcat strcat "^normal^" strcat swap " - " strcat swap strcat
	  then
	then
	over strlen over strlen or not if   ( if both strings are empty )
	  pop pop
	  break
	then

    swap 29 STRleft " " strcat swap strcat	( p1# p2# offer wanted index string )
	6 pick swap TellOne
	1 + dup 40 > if break then
  repeat
  pop pop pop pop

  "You may ^white^accept^normal^ or ^white^reject^normal^ this trade." TellOne
;

( For a player, check the trade string for legality of trading )
( Return 1 if ok, 0 if not )
( Prints complaints to current user! )
: TestTrade ( p# s -- f )
  ( Now, go through the offer and make sure we can actually offer everything listed )
  swap LocalTmp !
  " " explode
  begin dup while
    ( ensure there is something )
    swap dup strlen not if pop break then
	dup "$" 1 strncmp not if
	  ( this is cash )
      1 strcut swap pop atoi
      dup 0 < if
        "* You can not trade negative dollars." tellme
        pop flushstack
        0 exit
      then
      dup 0 = not if
        LocalTmp @ "Cash" GetPlayerVal > if
	      LocalTmp @ me @ dbcmp if
		    "* You don't have enough money for this trade." tellme
		  else 
		    "* " LocalTmp @ name strcat " does not have enough money for this trade." strcat tellme
          then
		  flushstack
		  0
		  exit
		then
	  else
	    pop
	  then
	else
	  ( this is property )
      atoi dup 0 = over 40 > or if
	    "* Invalid property number." tellme
		pop flushstack
		0
		exit
	  then
      LocalTmp @ over isTradable not if
	    "* " swap dup GetFullName swap intostr 2 STRleft " - " strcat swap strcat
		strcat " can not be traded (check ownership and that it's color group is undeveloped)." strcat tellme
		flushstack
		0
		exit
	  else
	    pop
	  then
	then
	1 -
  repeat
  pop
  1
;

( Offer a trade to another player )
( dotrade <name>=<offer> for <wanted> )
( dotrade <name> for lists )
( dotrade for help )
: dotrade ( s -- )
  dup "" strcmp not if
    ( No arguments, do help )
    pop
	"To compare what you and another player have, enter ^white^trade <name>" tellme
	"To actually offer a trade, enter ^white^trade <name>=<offer> for <wanted>" tellme
	"  ^white^<offer>^normal^ and ^white^<wanted>^normal^ are lists that describe the" tellme
	"  properties and/or cash to be traded. Cash is indicated as a dollar sign followed" tellme
	"  by a value (ie: ^white^$200^normal^), and properties are indicated simply as their" tellme
	"  ID number (ie: ^white^9^normal^ for Vermont Ave). You can see ID numbers with the" tellme
	"  ^white^status^normal^ command, or by viewing the board squares with the ^white^board^normal^ command." tellme
	"Property with houses or hotels can not be traded! The houses must be sold first. You may" tellme
	"still list them in your ^white^<wanted>^normal^ list, but the other player will not" tellme
	"be able to accept the trade until he sells them. This applies to all properties in" tellme
	"the color group." tellme
	" " tellme
	"Example trade:" tellme
	"^white^trade Marjan=$200 9 for 40" tellme
	"This offers to trade to Marjan, $200 cash and Vermont Ave (property 9), for Boardwalk (property 40)" tellme
	exit
  then

  dup "=" instr dup 0 = if
    ( Just a name, list property comparison )
    pop
    match 
    dup #-2 dbcmp if "* I don't know which player you mean" tellme exit then
    dup #-1 dbcmp if "* I can't find that player." tellme exit then
    dup #0 dbcmp if "* Unable to make a match." tellme exit then
	dup me @ dbcmp if "* You can't trade with yourself." tellme exit then
    dup location me @ location dbcmp not if "* That player is not in this room." tellme exit then

	dup "PlayingIn" GetPlayerStr
	me @ "PlayingIn" GetPlayerStr
	strcmp if "* " swap name strcat " is not playing in this game!" strcat tellme exit then

    "^white^You                           " over name strcat tellme

    1 1														( other# prop1 prop2 )
	begin
	  over 40 > over 40 > and if break then
	  ( build the string of one property each player )
	  ( Find a property on ourselves )
      swap													( other# prop2 prop1 )
	  begin
	    me @ "Property/" 3 pick intostr strcat GetPlayerVal ( other# prop2 prop1 houses )
		dup 0 > if break then								( other# prop2 prop1 houses )
		pop 1 +												( other# prop2 prop1 )
		dup 40 > if break then								( other# prop2 prop1 )
	  repeat
      
	  ( If greater than 40, we ran off the loop. Else we have a house count )
	  dup 40 > if
	    "                              "					( other# prop2 prop1 string )
	  else
	    7 = if												( other# prop2 prop1 )
		  "^gloom^*"										( other# prop2 prop1 string )
		else
		  dup GetColor										( other# prop2 prop1 string )
		then
		over dup GetFullName swap intostr 2 STRleft " - " strcat swap strcat strcat ( other# prop2 prop1 string )
		29 STRleft " " strcat								( other# prop2 prop1 string )
	  then
	  swap 1 + swap

	  rot 4 rotate swap										( prop1 string other# prop2 )
	  begin
	    over "Property/" 3 pick intostr strcat GetPlayerVal ( prop1 string other# prop2 houses )
		dup 0 > if break then								( prop1 string other# prop2 houses )
		pop 1 +												( prop1 string other# prop2 )
		dup 40 > if break then								( prop1 string other# prop2 )
	  repeat

	  ( Same as above if over 40, except we don't care to pad )
	  dup 40 > if											( prop1 string other# prop2 [houses] )
	    rot													( prop1 other# prop2 string )
	  else
        7 = if												( prop1 string other# prop2 )
		  "^gloom^*"										( prop1 string other# prop2 string2 )
		else
		  dup GetColor										( prop1 string other# prop2 string2 )
		then
		over dup GetFullName swap intostr 2 STRleft " - " strcat swap strcat strcat ( other# prop2 prop1 string )
		29 STRleft											( prop1 string other# prop2 string2 )
		4 rotate swap strcat								( prop1 other# prop2 string )
	  then
	  swap 1 + swap

	  tellme												( prop1 other# prop2 )
	  swap -3 rotate										( other# prop1 prop2 )
	repeat

	pop pop													( other# )
	me @ "Cash" GetPlayerVal intostr "Cash: $" swap strcat 30 STRleft
	swap "Cash" GetPlayerVal intostr "Cash: $" swap strcat strcat
	tellme

    "^gloom^* indicates mortgaged property (if any)" tellme

	exit
  then
  
  ( = was provided, so it's a full trade offer <name>=<offer> for <wanted> )
  ( string pos_of_equals )
  1 - strcut 1 strcut swap pop								( name offer_string )
  dup " for " instring
  dup 0 = if
    "* To trade, use ^white^trade ^gray^name^white^=^gray^offer^white^ for ^gray^wanted" tellme
	"  ^gray^offer^normal^ and ^gray^wanted^normal^ are lists of money or property IDs" tellme
	"  separated by spaces. For money, preface with a dollar sign ($)" tellme
	pop pop pop exit
  then
  
  1 - strcut 5 strcut swap pop    						( name offer wanted )
  me @ 3 pick TestTrade not if
    pop pop exit
  then

  ( The offer is okay, is the target? )
  3 pick match 
  dup #-2 dbcmp if "* I don't know which player you mean" tellme exit then
  dup #-1 dbcmp if "* I can't find that player." tellme exit then
  dup #0 dbcmp if "* Unable to make a match." tellme exit then
  dup me @ dbcmp if "* You can't trade with yourself." tellme exit then
  dup location me @ location dbcmp not if "* That player is not in this room." tellme exit then

  dup "PlayingIn" GetPlayerStr
  me @ "PlayingIn" GetPlayerStr
  strcmp if "* " swap name strcat " is not playing in this game!" strcat tellme exit then

  ( name offer wanted db# )
  ( Check whether the other player actually owns all the property wanted - ignore cash )
  dup LocalTmp !
  over " " explode
  begin dup while
    ( ensure there is something )
    swap dup strlen not if pop break then
	dup "$" 1 strncmp not if
	  ( this is cash - ignore for now )
      pop
	else
	  ( this is property )
      atoi dup 0 = over 40 > or if
	    "* Invalid property number." tellme
		pop flushstack
		exit
	  then
	  dup GetOwner LocalTmp @ dbcmp not if
	    "* " swap dup GetFullName swap intostr 2 STRleft " - " strcat swap strcat
		strcat " can not be traded (ensure player owns it)." strcat tellme
		flushstack
		exit
	  else
	    pop
	  then
	then
	1 -
  repeat
  pop

  ( So the offer appears to be good )
  "Trades/" me @ intostr strcat MakePlayerProp       ( name offer wanted db# prop )
  dup "/Offer" strcat 3 pick swap                    ( name offer wanted db# prop db# prop2 )
  6 pick 0 addprop
  dup "/Wanted" strcat 3 pick swap
  5 pick 0 addprop
  pop
  me @ ShowTrade
  pop pop 
  "Your offer has been sent to " swap match name strcat tellme
;

( Revoke a trade offer made to another player - before they accept! )
: dountrade ( s -- )
  dup "" strcmp not if
    "* You must specify who you want to revoke your trade with." tellme
	pop exit
  then

  match 
  dup #-2 dbcmp if "* I don't know which player you mean" tellme exit then
  dup #-1 dbcmp if "* I can't find that player." tellme exit then
  dup #0 dbcmp if "* Unable to make a match." tellme exit then
  dup me @ dbcmp if "* You can't trade with yourself." tellme exit then
  dup location me @ location dbcmp not if "* That player is not in this room." tellme exit then

  dup "PlayingIn" GetPlayerStr
  me @ "PlayingIn" GetPlayerStr
  strcmp if "* " swap name strcat " is not playing in this game!" strcat tellme exit then

  dup "Trades/" me @ intostr strcat "/Offer" strcat GetPlayerStr
  strlen 0 = if
    "* You have no pending trade with " swap name strcat tellme
	exit
  then

  dup "Trades/" me @ intostr strcat MakePlayerProp propremove
  dup "* " me @ name strcat " has revoked their trade offer." strcat TellOne
  "* You have revoked your trade offer to " swap name strcat tellme
;

( Remove trading props - propdir passed in )
: RemoveTrade ( db# s -- )
  over over "/Offer" strcat propremove
  "/Wanted" strcat propremove
;
 
( Reject a trade from another player )
( - Notify player )
( - Clean up props )
: doreject ( s -- )
  dup "" strcmp not if
    "* You must specify who you want to reject your trade from." tellme
	pop exit
  then

  match 
  dup #-2 dbcmp if "* I don't know which player you mean" tellme exit then
  dup #-1 dbcmp if "* I can't find that player." tellme exit then
  dup #0 dbcmp if "* Unable to make a match." tellme exit then
  dup me @ dbcmp if "* You can't trade with yourself." tellme exit then

  me @ "Trades/" 3 pick intostr strcat "/Offer" strcat GetPlayerStr
  strlen 0 = if
    "* You have no pending trade from " swap name strcat tellme
	exit
  then

  me @ "Trades/" 3 pick intostr strcat MakePlayerProp RemoveTrade
  dup "* " me @ name strcat " has declined your trade offer." strcat TellOne
  "* You have rejected the trade offer from " swap name strcat tellme
;
 
( Do one direction of a trade transaction - process the string from player to a player )
( Assumes legality is already tested and that no houses are involved )
( Unfortunately, we do need to track the mortgaged state - Property/1-40:7 )
( GetHouseCount will return 6 )
: DoHalfTrade ( from# to# str -- )
  swap LocalTmp2 !			( to# )
  swap LocalTmp !           ( from# )

  " " explode				( str str ... n )
  begin dup while
    ( ensure there is something )
    swap dup strlen not if pop break then
    dup "$" 1 strncmp not if
      ( this is cash )
      1 strcut swap pop atoi
      LocalTmp @ LocalTmp2 @ rot TransferCash
    else
      ( this is property )
      atoi dup 0 = over 40 > or if
        "* Skipping invalid property number." tellme
         pop
      else
        ( save whether it is mortgaged )
        dup GetHouseCount 1 + LocalTmp3 !
        ( change the owner )
        dup intostr "property/" swap strcat MakeGameProp LocalTmp2 @ int "" swap addprop
        ( Remove player's housecount )
        dup intostr "property/" swap strcat LocalTmp @ swap MakePlayerProp propremove
        ( update the player's colorgroup count )
        dup GetGroup "Groups/" swap strcat dup LocalTmp @ swap GetPlayerVal
        1 + swap LocalTmp @ swap MakePlayerProp rot "" swap addprop

        ( add new player's housecount )
        dup intostr "property/" swap strcat LocalTmp2 @ swap MakePlayerProp "" LocalTmp3 @ addprop
        ( update the player's colorgroup count )
        dup GetGroup "Groups/" swap strcat dup LocalTmp2 @ swap GetPlayerVal
        1 - 
        dup 0 = if
          LocalTmp2 @ name " now has a complete color group!" strcat tellplayers
        then
        swap LocalTmp2 @ swap MakePlayerProp rot "" swap addprop

        LocalTmp @ name " transfers " strcat swap GetFullName strcat
        " to " strcat LocalTmp2 @ name strcat tellplayers
      then
    then
	1 -
  repeat
  pop
;

( Accept a trade from another player )
( - Verify that the trade is possible on both sides )
( - Transfer the properties/cash/cards - watch for mortgaged props! )
( - Clean up props on both players )
( - Notify all players )
( - Future: 10% bank fee on mortgaged properties )
: doaccept ( s -- )
  dup "" strcmp not if
    "* You must specify who you want to accept your trade from." tellme
	pop exit
  then

  match 
  dup #-2 dbcmp if "* I don't know which player you mean" tellme exit then
  dup #-1 dbcmp if "* I can't find that player." tellme exit then
  dup #0 dbcmp if "* Unable to make a match." tellme exit then
  dup me @ dbcmp if "* You can't trade with yourself." tellme exit then
  dup location me @ location dbcmp not if "* That player is not in this room." tellme exit then

  me @ "Trades/" 3 pick intostr strcat "/Offer" strcat GetPlayerStr
  dup strlen 0 = if
    pop
    "* You have no pending trade from " swap name strcat tellme
    exit
  then

  over over TestTrade not if
    pop exit
  then								( db# offer )

  me @ "Trades/" 4 pick intostr strcat "/Wanted" strcat GetPlayerStr
  me @ over TestTrade not if
    pop pop exit
  then								( db# offer wanted )

  ( it looks as though the trade is allowable )
  me @ name " accepts a trade with " strcat 4 pick name strcat tellplayers
  me @ 4 pick rot DoHalfTrade		( db# offer )
  over me @ rot DoHalfTrade         ( db# )

  me @ "Trades/" rot intostr strcat MakePlayerProp RemoveTrade
;
 
( Display details on all outstanding trades )
: dotrading ( -- )
  0 localtmp !
  me @ "Trades/" makeplayerprop swap pop
  begin me @ swap nextprop dup "" strcmp while           ( str )
    localtmp @ 1 + localtmp !
    dup dup "/" rinstr strcut swap pop atoi dbref        ( convert the prop name to player # - str #)
    me @ swap showtrade                                  ( str )
  repeat
  pop
  localtmp @ 0 = if
    "You have no pending trades." tellme
  then
;

( Display current portfolio <money, properties, and if there are any outstanding trades> )
: doportfolio ( -- )
  ( show cash )
  me @ "Cash" GetPlayerVal
  intostr "You have ^white^$" swap strcat "^normal^ in cash." strcat tellme
  
  ( show properties )
  " " tellme
  "Properties" tellme
  "----------" tellme

  (disable debug except during found properties)
  prog "D" flag? tmpdebug !
  prog "!D" set
  ( --- )

  1
  begin
    dup GetOwner
  	me @ dbcmp if
      (enable debug if needed)
      tmpdebug @ if prog "D" set then

  	  dup GetColor
  	  over intostr strcat " - " strcat
  	  over GetFullName strcat 
  	  over GetHouseCount (subtracts 1 so that you get true count for houses)
  	  dup 0 = if ""
  	  else dup 1 = if " (1 house)"
  	  else dup 2 = if " (2 houses)"
  	  else dup 3 = if " (3 houses)"
  	  else dup 4 = if " (4 houses)"
  	  else dup 5 = if " (hotel)"
  	  else dup 6 = if " (mortgaged)"
  	  else " (dberr)"
  	  then then then then then then then
  	  swap pop strcat
  	  " - $" strcat over GetPrice intostr strcat tellme
      
      (disable again - don't need to test for it)
      prog "!D" set

  	then
  	1 + 
	dup 40 > if break then
  repeat

  (enable debug if needed)
  tmpdebug @ if prog "D" set then

  pop 
  
  ( show trades )
  " " tellme
  me @ "Outstanding Trades (^white^accept^normal^ or ^white^reject^normal^)" tellone
  me @ "-------------------------------------" tellone
  dotrading
;
 
( Game owner may drop a player, if he's gone, anyone may )
: dodrop ( s -- )
  ( check for owner )
  "Players" MakeGameProp
  REF-allrefs
  1 -
  begin dup while
    swap pop 1 -
  repeat
  pop
  dup me @ dbcmp if
    ( I am the owner, so we can drop if the player is offline )
    pop match dup awake? if
      name " is still connected, can not be dropped." strcat tellme
    else 
      me @ name " has dropped " strcat over name strcat " from the game." strcat tellplayers
      leavegame
    then
  else 
    ( I am not the owner, is the owner online? )
    awake? if
      "The game owner must perform the drop operation." tellme
    else
      match dup awake? if
        name " is still connected, can not be dropped." strcat tellme
      else 
        me @ name " has dropped " strcat over strcat " from the game." strcat tellplayers
        leavegame
      then
    then
  then
;
 
( Register to watch a game )
: dowatch ( s -- )
  me @ "PlayingIn" GetPlayerStr dup "" strcmp if
    "* You are already playing in game " swap strcat ". Use 'leave' to quit that game." strcat tellme
    exit
  then 
  pop
  atoi dup 0 = if
    "* Please specify the game number to watch. Use 'game <name>' to see which game someone else is in." tellme
    pop exit
  then
  intostr
  dup "Players" GetGameNStr "" strcmp not if
    "* Game " swap strcat " does not exist." strcat tellme
    exit
  then
 
  ( add to game as a spectator )
  dup "Watchers" MakeGameNProp me @ REF-add
 
  "You are now watching game " swap strcat ". Stop watching by leaving the room or joining a game." strcat tellme
;
 
: doretire ( -- )
  me @ "PlayingIn" GetPlayerStr dup "" strcmp not if
    "* You are not currently playing any game!" tellme
    pop
    exit
  then 

  doleave
  dowatch
;
 
( Purchase a property landed on after a roll )
( - Reduce cash )
( - Grant property )
( - Notify players )
: dopurchase ( -- )
  "Turn" GetGameVal dbref me @ dbcmp not if
    "* It's not your turn." tellme
    exit
  then
 
  "Phase" GetGameVal 
  dup 3 = if
    "* The game is waiting for you to get out of debt, or 'retire'." tellme
	pop 
	exit
  then
  2 = not if
    "* You aren't in buy mode. Go ahead and 'roll'." tellme
    exit
  then
 
  ( Check for sufficient cash )
  me @ "Cash" GetPlayerVal
  me @ "Location" getplayerval 
 
  dup GetPrice 3 pick > if
    "* You do not have sufficient cash to purchase this property." tellme
    "* You have: $" rot intostr strcat tellme
    "* You need: $" swap GetPrice intostr strcat tellme
    "* You may ^white^sell^normal^ houses, ^white^mortgage^normal^ property, or ^white^trade^normal^ to raise funds." tellme
    "* Or you may ^white^pass^normal^ to not purchase at this time." tellme
  else
    swap pop
    dup GetFullName me @ name " ^green^purchases^normal^ " strcat swap strcat tellplayers
    dup me @ swap GetPrice DeductCash
    "Property/" over intostr strcat MakeGameProp "" me @ int addprop
    me @ "Property/" 3 pick intostr strcat MakePlayerProp "" 1 addprop
    dup GetGroup dup "x" strcmp if
      "Groups/" over strcat me @ swap GetPlayerVal
      1 -
      dup 0 = if
        me @ name " now has a complete color group!" strcat tellplayers
      then
      "Groups/" 3 pick strcat me @ swap MakePlayerProp "" 4 rotate addprop
    then
    pop
    DoNextTurn
  then
;
 
( Pass on a property landed on after a roll )
( - Notify players )
( - <future?> Allow auction? )
: dopass ( -- )
  "Turn" GetGameVal dbref me @ dbcmp not if
    "* It's not your turn." tellme
    exit
  then
 
  "Phase" GetGameVal 
  dup 3 = if
    "* The game is waiting for you to get out of debt, or 'retire'." tellme
	pop 
	exit
  then
  2 = not if
    "* You aren't in buy mode. Go ahead and 'roll'." tellme
    exit
  then
  
  me @ "Location" getplayerval GetFullName
  me @ name " does ^red^not^normal^ purchase " strcat swap strcat tellplayers
  DoNextTurn
;
 
( Buy houses for a property )
( - Notify players )
( Future: enforce even development )
: dobuyone ( s -- )
  ( valid? )
  dup "" strcmp not over atoi dup 1 < swap 40 > or or if
    pop "* You must specify a property number 1-40 to put a house on" tellme
	exit
  then

  ( owner? )
  atoi dup GetOwner
  me @ dbcmp not if
    "* You don't own " swap GetFullName strcat tellme
	exit
  then

  ( actual property? )
  dup GetType "A" stringcmp if
    "* You may not place houses on " swap GetFullName strcat tellme
	exit
  then

  ( color group )
  dup GetGroup "Groups/" swap strcat me @ swap GetPlayerVal
  0 = not if
    "* You do not own the full color group for " swap getfullname strcat tellme
	exit
  then

  ( mortgaged? and remember house count )
  dup GetHouseCount dup 6 = if
    pop
    "* " swap GetFullName strcat " is mortgaged and may not be developed." strcat tellme
	exit
  then

  ( Hotel already? )
  dup 5 = if
    pop
	"* " swap GetFullName strcat " already has a hotel on it." strcat tellme
	exit
  then

  ( houses left? )
  dup 4 = not if
    "HousesLeft" GetGameVal 1 < if
      pop pop "* There are no houses available - you must wait until someone buys a hotel or sells houses." tellme
	  exit
	then
  else
    "HotelsLeft" GetGameVal 1 < if
      pop pop "* There are no hotels available - you must wait until someone sells one." tellme
	  exit
	then
  then

  ( enough money )
  over GetHouse me @ "Cash" GetPlayerVal over < if
    3 pick PrintADeed
    "* Houses cost $" swap intostr strcat ". You don't have enough." strcat tellme
	pop pop
	exit
  then
  me @ swap DeductCash

  ( 2 +, not 1, because GetHouseCount subtracts 1 to return a real value, and we need )
  ( to write a real value. We do one here, print the text, then add another below.    )
  1 +

  dup 4 > if
    over getfullname ". (Four houses traded in)." strcat 
	me @ name " buys a Hotel for " strcat swap strcat tellplayers
	"HousesLeft" GetGameVal 4 + "HousesLeft" MakeGameProp "" 4 rotate addprop
	"HotelsLeft" GetGameVal 1 - "HotelsLeft" MakeGameProp "" 4 rotate addprop
  else
    over over intostr " now has " swap strcat " houses." strcat
    swap getfullname swap strcat me @ name " buys a house. " strcat swap strcat tellplayers
	"HousesLeft" GetGameVal 1 - "HousesLeft" MakeGameProp "" 4 rotate addprop
  then

  1 +
  swap "Property/" swap intostr strcat MakePlayerProp me @ swap 
  "" 4 rotate addprop
;

( buy houses for one or more properties, space separated )
( just wraps dobuyone )
: dobuy ( s -- )
  " " explode  ( s ... i )
  begin dup while 1 -
    swap dobuyone
  repeat
  pop
;
  
( Sell houses on a property )
( Future: enforce even building )
( - Notify players )
: dosellone ( s -- )
  ( valid? )
  dup "" strcmp not over atoi dup 1 < swap 40 > or or if
    pop "* You must specify a property number 1-40 to sell a house from" tellme
	exit
  then

  ( owner? )
  atoi dup GetOwner
  me @ dbcmp not if
    "* You don't own " swap GetFullName strcat tellme
	exit
  then

  ( mortgaged? and remember house count )
  dup GetHouseCount dup 6 = if
    pop
    "* " swap GetFullName strcat " is mortgaged and has no houses." strcat tellme
	exit
  then

  ( Empty? )
  dup 0 = if
    pop
	"* " swap GetFullName strcat " has no houses on it." strcat tellme
	exit
  then

  ( Don't subtract at all, because GetHouseCount subtracts 1 to return a real value, and we need )
  ( to write a real value. )

  dup 4 > if
    ( do money - a hotel is 5 houses )
    "HousesLeft" GetGameVal 3 > if
      (trade a hotel for 4 houses)
      over GetHouse 2 / me @ swap AddCash
      ( Report )
      over getfullname "." strcat 
  	  me @ name " trades a Hotel from " strcat swap strcat " for four houses." strcat tellplayers
	  "HotelsLeft" GetGameVal 1 + "HotelsLeft" MakeGameProp "" 4 rotate addprop
	  "HousesLeft" GetGameVal 4 - "HousesLeft" MakeGameProp "" 4 rotate addprop
    else
      (not enough houses - sell hotel)
      over GetHouse 5 * 2 / me @ swap AddCash
      ( Report )
      over getfullname "." strcat 
  	  me @ name " sells a Hotel from " strcat swap strcat " (not enough houses free)." strcat tellplayers
	  "HotelsLeft" GetGameVal 1 + "HotelsLeft" MakeGameProp "" 4 rotate addprop
	  pop 1  (replaces current count with 0 houses)
	then
  else
    ( do money )
    over GetHouse 2 / me @ swap AddCash
    over over 1 - intostr " now has " swap strcat " houses." strcat
    swap getfullname swap strcat me @ name " sells a house. " strcat swap strcat tellplayers
	"HousesLeft" GetGameVal 1 + "HousesLeft" MakeGameProp "" 4 rotate addprop
  then

  swap "Property/" swap intostr strcat MakePlayerProp me @ swap 
  "" 4 rotate addprop
;

( sell houses for one or more properties, space separated )
( just wraps dosellone )
: dosell ( s -- )
  " " explode  ( s ... i )
  begin dup while 1 -
    swap dosellone
  repeat
  pop
;
 
( Mortgage a property )
: domortgage ( s -- )
  ( valid? )
  dup "" strcmp not over atoi dup 1 < swap 40 > or or if
    pop "* You must specify a property number 1-40 to mortgage" tellme
	exit
  then

  ( owner? )
  atoi dup GetOwner
  me @ dbcmp not if
    "* You don't own " swap GetFullName strcat tellme
	exit
  then

  ( mortgaged? )
  dup GetHouseCount 6 = if
    "* " swap GetFullName strcat " is already mortgaged!" strcat tellme
	exit
  then

  ( Check color group for houses - we can just use isTradable )
  me @ over isTradable not if
	"* " swap GetFullName strcat " is in a developed color group - all properties must be clear of houses before mortgaging." strcat tellme
	exit
  then
  
  ( GetMort returns 0 on invalid types )
  dup GetMort dup 0 = if
    pop
	"* You can not mortgage " swap getfullname strcat tellme
	exit
  then
  
  ( don't allow when a trade is pending - we can't easily check if it's this property so block for all )
  hasPendingTrades if
    "* You have pending trades to resolve before you can mortgage anything (use 'trading' to see)." tellme
    exit
  then

  ( All right, then )
  dup me @ swap AddCash

  ( tell everyone )
  me @ name " has mortgaged " strcat 3 pick GetFullName strcat " for $" strcat swap intostr strcat
  tellplayers

  ( And mark it mortgaged )
  "Property/" swap intostr strcat me @ swap MakePlayerProp "" 7 addprop
;
 
( Unmortgage a property )
: dounmortgage ( s -- )
  ( valid? )
  dup "" strcmp not over atoi dup 1 < swap 40 > or or if
    pop "* You must specify a property number 1-40 to un-mortgage" tellme
	exit
  then

  ( owner? )
  atoi dup GetOwner
  me @ dbcmp not if
    "* You don't own " swap GetFullName strcat tellme
	exit
  then

  ( mortgaged? )
  dup GetHouseCount 6 = not if
    "* " swap GetFullName strcat " is not mortgaged!" strcat tellme
	exit
  then

  ( GetMort returns 0 on invalid types )
  dup GetMort dup 0 = if
    pop
	"* You can not mortgage " swap getfullname strcat tellme
	exit
  then

  ( Enough Money? - Mortgage cost + 10% )
  dup 5 + 10 / +                 ( the +5 makes it round up )
  me @ "Cash" GetPlayerVal
  over < if
	"* You don't have enough cash. You need $" swap intostr strcat " to unmortgage " strcat
	swap GetFullName strcat " (cost + 10%)" strcat tellme
	exit
  then

  ( All right, then )
  dup me @ swap DeductCash

  ( tell everyone )
  "The unmortgage cost is $" swap intostr strcat tellme
  me @ name " has unmortgaged " strcat over GetFullName strcat
  tellplayers

  ( And mark it available )
  "Property/" swap intostr strcat me @ swap MakePlayerProp "" 1 addprop
;
 
( Pay $50 bail to get out of jail )
( - Verify actually in jail )
( - Verify enough money )
( - Deduct money )
( - Move out of jail and notify players )
( - Instruct player to roll if it's his turn )
: dobail ( -- )
  me @ "InJail" GetPlayerVal not if
    "* You aren't IN jail!" tellme
    exit
  then
 
  me @ "Cash" GetPlayerVal dup 50 < if
    "* You don't have enough money ($50). You only have $" swap intostr strcat tellme
    exit
  then
 
  me @ name " pays the $50 fine and is out of jail." strcat tellplayers
 
  50 - me @ "Cash" MakePlayerProp "" 4 rotate addprop
  me @ "InJail" MakePlayerProp "" 0 addprop
 
  "Turn" GetGameVal dbref me @ dbcmp if
    "Type 'roll' to roll the dice." tellme
  then
;
 
( Use a 'Get out of Jail Free' card )
( - Verify actually in jail )
( - Verify has a card )
( - Deduct card )
( - Move out of jail and notify players )
( - Instruct player to roll if it's his turn )
: docard ( -- )
  me @ "InJail" GetPlayerVal not if
    "* You aren't IN jail!" tellme
    exit
  then
 
  me @ "JailFree" GetPlayerVal dup not if
    "* You don't have any 'Get Out of Jail Free' cards." tellme
    pop
    exit
  then
 
  me @ name " uses a 'Get Out of Jail Free' card and is out of jail." strcat tellplayers
 
  1 - me @ "JailFree" MakePlayerProp "" 4 rotate addprop
  me @ "InJail" MakePlayerProp "" 0 addprop

  ( Update the card stacks. Since there is only one GOOJF card in each deck, we can cheat a bit )
  me @ "ChanceJailFree" GetPlayerVal if
    me @ "ChanceJailFree" MakePlayerProp "" 0 addprop
	"Chance" GetGameStr JAILFREECARD strcat
	"Chance" MakeGameProp rot 0 addprop 
  else
    me @ "CommJailFree" MakePlayerProp "" 0 addprop
	"CommChest" GetGameStr JAILFREECARD strcat
	"CommChest" MakeGameProp rot 0 addprop 
  then
 
  "Turn" GetGameVal dbref me @ dbcmp if
    "Type 'roll' to roll the dice." tellme
  then
;
 
( Display a deed on a property )
: dodeed ( s -- )
  atoi
  dup 1 >= over 40 <= and not if
    "* Board ranges from 1-40" tellme
    pop exit
  then
  
  dup GetType
 
  dup "A" strcmp not over "D" strcmp not or over "G" strcmp not or if
    pop PrintADeed
    exit
  then
 
  pop
  "( NOTE: Square " over intostr strcat " is not a property! )" strcat tellme
  DrawSquare
;
 
( Display a requested square on the board )
: doboard ( s -- )
  atoi
  dup 0 = if
    ( draw the whole board )
    "^white^___________________________________________________________________________" tellme
    "^white^ ____^gray^21^white^______^gray^22^white^____^gray^23^white^____^gray^24^white^____^gray^25^white^____^gray^26^white^____^gray^27^white^____^gray^28^white^____^gray^29^white^____^gray^30^white^______^gray^31^white^___ " tellme
    "^white^|   ^red^,o,   ^white^|     |     |     |     |     |     |     |     |     |         |" tellme
    "^white^|   ^red^#^white^o^red^#   ^white^|     |     |     |     | , ,.|     |     |.    |     |    ^blue^GO   ^white^|" tellme
    "^white^|  ^red^d###b  ^white^|     |     |     |     | xxxo|     |     |`=p=O|     |    ^blue^TO   ^white^|" tellme
    "^white^|  ^white^U   U  ^white^|^red^#####^white^|  ?  ^white^|^red^#####^white^|^red^#####^white^| \" ' |^yellow^#####^white^|^yellow^#####^white^| -\"- |^yellow^#####^white^|   ^blue^JAIL  ^white^|" tellme
    "^white^|_________|^red^#####^white^|_____|^red^#####^white^|^red^#####^white^|_____|^yellow^#####^white^|^yellow^#####^white^|_____|^yellow^#####^white^|_________|" tellme
    "^white^|      ^brown^###^white^|                                                     |^green^###      ^white^|" tellme
    "^gray^20^white^     ^brown^###^white^|                                                     |^green^###     ^gray^32" tellme
    "^white^|______^brown^###^white^|                                                     |^green^###^white^______|" tellme
    "^white^|      ^brown^###^white^|                                                     |^green^###      ^white^|" tellme
    "^gray^19^white^     ^brown^###^white^|                                                     |^green^###     ^gray^33" tellme
    "^white^|______^brown^###^white^|                                                     |^green^###^white^______|" tellme
    "^white^|    COMM.|                                                     |COMM.    |" tellme
    "^gray^18^white^   CHEST|                                                     |CHEST   ^gray^34" tellme
    "^white^|_________|                                                     |_________|" tellme
    "^white^|      ^brown^###^white^|                                                     |^green^###      ^white^|" tellme
    "^gray^17^white^     ^brown^###^white^|                                                     |^green^###     ^gray^35" tellme
    "^white^|______^brown^###^white^|                                                     |^green^###^white^______|" tellme
    "^white^|     , _ |                                                     |  , _    |" tellme
    "^gray^16^white^   ojxj |                                                     | ojxj   ^gray^36" tellme
    "^white^|_________|                                                     |_________|" tellme
    "^white^|      ^purple^###^white^|                                                     |         |" tellme
    "^gray^15^white^     ^purple^###^white^|                                                     | ?     ^gray^37" tellme
    "^white^|______^purple^###^white^|                                                     |_________|" tellme
    "^white^|      ^purple^###^white^|                                                     |^blue^###      ^white^|" tellme
    "^gray^14^white^     ^purple^###^white^|                                                     |^blue^###     ^gray^38" tellme
    "^white^|______^purple^###^white^|                                                     |^blue^###^white^______|" tellme
    "^white^|    ^yellow^__   ^white^|                                                     | INC     |" tellme
    "^gray^13^white^ ^gloom^x^yellow^<__)  ^white^|                                                     | TAX    ^gray^39" tellme
    "^white^|_________|                                                     |_________|" tellme
    "^white^|      ^purple^###^white^|                                                     |^blue^###      ^white^|" tellme
    "^gray^12^white^     ^purple^###^white^|                                                     |^blue^###     ^gray^40" tellme
    "^white^|______^purple^###^white^|_____________________________________________________|^blue^###^white^______|" tellme
    "^white^| ^red^########^white^|^cyan^#####^white^|^cyan^#####^white^|     |^cyan^#####^white^| , _ |     |^violet^#####^white^|     |^violet^#####^white^|         |" tellme
    "^white^| ^red^##^gloom^||||^red^##^white^|^cyan^#####^white^|^cyan^#####^white^|  ?  ^white^|^cyan^#####^white^|oxxx | INC |^violet^#####^white^|COMM.|^violet^#####^white^| ^red^### ### ^white^|" tellme
    "^white^| ^red^##^gloom^||||^red^##^white^|     |     |     |     |'\" \" | TAX |     |CHEST|     | ^red^# _ # # ^white^|" tellme
    "^white^| ^red^########^white^|     |     |     |     |     |     |     |     |     | ^red^### ### ^white^|" tellme
    "^white^|____^gray^11^white^___|__^gray^10^white^_|__^gray^9^white^__|__^gray^8^white^__|__^gray^7^white^__|__^gray^6^white^__|__^gray^5^white^__|__^gray^4^white^__|__^gray^3^white^__|__^gray^2^white^__|____^gray^1^white^____|" tellme
    "^white^___________________________________________________________________________" tellme
	"Use ^white^board X^normal^ (where X is a square number) to view a particular square" tellme
	pop exit
  then
  dup 1 >= over 40 <= and not if
    "* Board ranges from 1-40" tellme
    pop exit
  then
  
  DrawSquare
;

( list properties with owners and not yet owned )
: dostatus ( s -- )
  dup "" strcmp not if
    me @ "PlayingIn" GetPlayerStr dup "" strcmp not if
      "* You are not in any game! (Try 'status <game number>')" tellme
      exit
    then 
  else
    ( are you playing in a game? don't overwrite! )
    me @ "PlayingIn" GetPlayerStr "" strcmp if
      "* You can only view your own game! (Don't include the game number)" tellme
      exit
    then

    ( is it a valid game? )
    dup "Players" GetGameNStr "" strcmp not if
      "* Game " swap strcat " does not exist." strcat tellme
      exit
    then      
  
    ( need to temporarily log into a game for this report )
    dup me @ "PlayingIn" MakePlayerProp rot 0 addprop
    me @ "dummygame" MakePlayerProp "1" 0 addprop
  then

  1
  begin
    dup GetOwner
	dup #0 dbcmp if
	  pop
	  dup GetMort 0 = if
	    ( non-property )
		"^gloom^"
	  else 
	    dup GetColor
	  then
      over dup GetFullName swap intostr 2 STRleft " - " strcat swap strcat strcat 36 STRleft
	else
	  name over GetColor 3 pick dup GetFullName swap intostr 2 STRleft " - " strcat swap strcat strcat 26 STRleft 
	  3 pick GetHouseCount dup 0 = if
	    pop
	  else
	    swap 23 STRleft swap  
		dup 6 = if pop "^gloom^(M)" strcat 
		  else dup 5 = if pop "^red^(H)" strcat
		    else swap "^forest^(" strcat swap intostr strcat ")" strcat
		  then
		then
	  then
	  "^normal^->" strcat swap strcat 36 STRleft
	then
    " " strcat
	swap 20 +
    dup GetOwner
	dup #0 dbcmp if
	  pop
	  dup GetMort 0 = if
	    ( non-property )
		"^gloom^"
	  else 
	    dup GetColor
	  then
	  over dup GetFullName swap intostr 2 STRleft " - " strcat swap strcat strcat 36 STRleft
	else
	  name over GetColor 3 pick dup GetFullName swap intostr 2 STRleft " - " strcat swap strcat strcat 26 STRleft 
	  3 pick GetHouseCount dup 0 = if
	    pop
	  else
	    swap 23 STRleft swap  
		dup 6 = if pop "^gloom^(M)" strcat 
		  else dup 5 = if pop "^red^(H)" strcat
		    else swap "^forest^(" strcat swap intostr strcat ")" strcat
		  then
		then
	  then
	  "^normal^->" strcat swap strcat 36 STRleft
	then
    rot swap strcat tellme
	19 -
	dup 20 > if break then
  repeat
  pop 

  " " tellme

  ( Now report each players location and cash )
  "Player         Location                      Cash" tellme
  "----------------------------------------------------" tellme
  "Players" MakeGameProp
  REF-allrefs
  begin dup while
    swap dup name 15 STRleft					( ... cnt db# string )
	over "Location" GetPlayerVal				( ... cnt db# string sq )
	dup intostr 2 STRleft " - " strcat
	swap GetFullName 25 STRleft strcat strcat "$" strcat
	over "Cash" GetPlayerVal intostr strcat
	tellme pop
    1 -
  repeat
  pop

  ( And, whose turn it is! )
  "Turn" GetGameVal dbref
  "----------------------------------------------------" tellme
  dup #0 dbcmp if
    pop "The game has not yet been started." tellme
  else
    "It is now " swap name strcat "'s turn." strcat tellme  
  then
  
  ( remove watchers from the list )
  me @ "dummygame" GetPlayerStr "" strcmp if
    me @ "DummyGame" MakePlayerProp propremove
    me @ "PlayingIn" MakePlayerProp propremove
  then

;
 
( Find out which game # 'player' is in, or list all players if it's a number )
: dogame ( s -- )
  dup "" strcmp not if
    pop "* You must specify a player name to match." tellme
	exit
  then

  dup atoi dup if
    swap pop
	( List game # )
	intostr dup "Players" MakeGameNProp REF-list 
	dup "" strcmp not if
	  pop
	  "There are no players in game " swap strcat tellme
	else
      "The following players are in game " rot strcat ": " strcat
	  swap strcat tellme
    then
	exit
  else
    pop
  then

  match 
  dup #-2 dbcmp if pop "* I don't know which player you mean" tellme exit then
  dup #-1 dbcmp if pop "* I can't find that player." tellme exit then
  dup #0 dbcmp if pop "* Unable to make a match." tellme exit then
  dup location me @ location dbcmp not if pop "* That player is not in this room." tellme exit then
  dup "PlayingIn" GetPlayerStr dup "" strcmp not if swap name " is not playing in any game." strcat tellme exit then
  swap name " is playing in game #" strcat swap strcat tellme
;
 
( special feature )
lvar feepvar

: fixstring ( s i -- s )
  ( get just the useful part of the string )
  strcut swap pop
  ( fix up pronouns and stuff )
  " you~" " i " subst
  " I~" " you " subst
  " I'm~" " youre " subst
  " you're~" " im " subst
  " my~" " your " subst
  " your~" " my " subst
  " mine~" " yours " subst
  " yours~" " mine " subst
  " me~" " you " subst
  " you~" " me " subst
  " are~" " am " subst
  " am~" " are " subst
  " were~" " was " subst
  " was~" " were " subst
  ( the ~ prevents double substitution, now we can change it back to a space )
  " " "~" subst
  strip
;

: gethatestr ( s i -- s )
  fixstring
  feepvar @ 1 = if  "Why do you hate " swap strcat "?" strcat exit then
  feepvar @ 2 = if pop "It's not healthy to hate." exit then
   "What if we all hated " swap strcat "?" strcat
;

: getlovestr ( s i -- s )
  fixstring
  feepvar @ 1 = if pop "Ah, love is good, isn't it?" exit then
  feepvar @ 2 = if  "What do you think about love and " swap strcat "?" strcat exit then
  pop "What does love really mean to you?"
;

: getwantstr ( s i -- s )
  fixstring
  feepvar @ 1 = if  "Do you think it's reasonable to want " swap strcat "?" strcat exit then
  feepvar @ 2 = if "What if we all wanted " swap strcat "?" strcat exit then
   "How long have you wanted " swap strcat "?" strcat
;

: getneedstr ( s i -- s )
  fixstring
  feepvar @ 1 = if  "Do you think it's normal to need " swap strcat "?" strcat exit then
  feepvar @ 2 = if  "Sometimes I also need " swap strcat "?" strcat exit then
  pop "Many people need many things."
;

: gettryingstr ( s i -- s )
  fixstring
  feepvar @ 1 = if pop "Some say 'Do, or do not, there is no 'try'.' What do you think?" exit then
  feepvar @ 2 = if  "How long should it take to " swap strcat "?" strcat exit then
  pop "Have you considered a different approach?"
;

: getdontstr ( s i -- s )
  fixstring
  feepvar @ 1 = if pop "That seems a bit negative. Denial, maybe?" exit then
  feepvar @ 2 = if  "What if I said that I " swap strcat "?" strcat exit then
   "Maybe you should " swap strcat "?" strcat
;

: getcantstr ( s i -- s )
  fixstring
  feepvar @ 1 = if pop "Have you tried?" exit then
  feepvar @ 2 = if  "What would it mean to you to " swap strcat "?" strcat exit then
   "You need a more positive outlook - you should say 'I can " swap strcat "!'" strcat
;

: getlikestr ( s i -- s )
  fixstring
  feepvar @ 1 = if  "I also like " swap strcat "." strcat exit then
  feepvar @ 2 = if  "What does " swap strcat " mean to you?" strcat exit then
   "How would you feel if " swap strcat " disappeared?" strcat
;

: getwhystr ( s i -- s )
  fixstring
  feepvar @ 1 = if pop "Why do you ask?" exit then
  feepvar @ 2 = if  "Have you ever tried to learn why " swap strcat "?" strcat exit then
  pop "Do you often wonder why?"
;

: gethowstr ( s i -- s )
  fixstring
  feepvar @ 1 = if  "Do you know anyone who knows " swap strcat "?" strcat exit then
  feepvar @ 2 = if pop "Do you wonder about that often?" exit then
  pop "What would be the best solution?"
;

: getwhatstr ( s i -- s )
  fixstring
  feepvar @ 1 = if pop "What would it mean if there was no answer?" exit then
  feepvar @ 2 = if  "Should I know what " swap strcat "?" strcat exit then
  pop "How do you feel when you think about that?"
;

: getyoustr ( s i -- s )
  fixstring
  feepvar @ 1 = if pop "I'm far more interested in you." exit then
  feepvar @ 2 = if  "Do you want me to " swap strcat "?" strcat exit then
   "Ah, I " swap strcat "." strcat
;

: getiamstr ( s i -- s )
  fixstring
  feepvar @ 1 = if  "Do you enjoy being " swap strcat "?" strcat exit then
  feepvar @ 2 = if  "Do you know any others who are " swap strcat "?" strcat exit then
   "Do you feel being " swap strcat " is acceptable to your friends?" strcat
;

: getnokeystr ( s -- s )
  pop
  feepvar @ 1 = if "That's very interesting, tell me more." exit then
  feepvar @ 2 = if "I see. How does that make you feel?" exit then
  "How does that affect what you want out of life?"
;

: dofeep ( -- )
  ( make sure this never runs locked or preempt )
  "This game would have been impossible without assistance from" tellme
  "Marjan, who did the artwork and insisted on my implementing color," tellme
  "as well as the testing of FoxxFire and Rabitguy. Further thanks" tellme
  "to Karna and the Flamehouse crew for letting me use it as a" tellme
  "testbed for the lib-ansi compatibility!" tellme
  " " tellme
  "Now, because you expected SOMETHING more than that, talk to the shrink..." tellme
  " " tellme
  0 feepvar !
  "(type 'bye' to exit)" tellme
  "Hi there! I am Dr. Zam. Eliza couldn't make it. What's your problem?" tellme
  begin
    read tolower 
	( next reply - 3 of each )
    feepvar @ 1 + dup 3 > if pop 1 then feepvar !
	( remove punctuation & smilies )
	"" "'" subst
	"" "," subst
	"" ";" subst
	"" ":" subst
	"" "-" subst
	"" ")" subst
	"" "(" subst
	"" ">" subst
	"" "<" subst
	" and " "&" subst
    ( only take the first sentence )
	dup "." instr dup if 1 - strcut then pop
    dup "!" instr dup if 1 - strcut then pop
	dup "?" instr dup if 1 - strcut then pop
	( pad the line )
    " " strcat " " swap strcat
	( find keywords and get reply )
	dup " hate " instring dup if 5 + gethatestr tellme continue else pop then
	dup " love " instring dup if 5 + getlovestr tellme continue else pop then
	dup " want " instring dup if 5 + getwantstr tellme continue else pop then
	dup " need " instring dup if 5 + getneedstr tellme continue else pop then
	dup " you " instring dup  if 4 + getyoustr tellme continue else pop then
	dup " trying " instring dup if 7 + gettryingstr tellme continue else pop then
	dup " try " instring dup if 4 + gettryingstr tellme continue else pop then
	dup " dont " instring dup if 5 + getdontstr tellme continue else pop then
	dup " do not " instring dup if 7 + getdontstr tellme continue else pop then
	dup " cant " instring dup if 5 + getcantstr tellme continue else pop then
	dup " can not " instring dup if 8 + getcantstr tellme continue else pop then
	dup " like " instring dup if 5 + getlikestr tellme continue else pop then
	dup " why " instring dup if 4 + getwhystr tellme continue else pop then
	dup " how " instring dup if 4 + gethowstr tellme continue else pop then
	dup " what " instring dup if 5 + getwhatstr tellme continue else pop then
	dup " i am " instring dup if 5 + getiamstr tellme continue else pop then
	dup " im " instring dup if 3 + getiamstr tellme continue else pop then
	( that's enough, check for end )
	dup " bye " stringcmp not if pop break then
	dup " quit " stringcmp not if pop break then
	getnokeystr tellme
  repeat
  "Nice talking to you!" tellme
;

( Testing helpers )
: dotest ( s -- )
  dup "jail" stringcmp not if
    ( Test going to jail! )
    me @ name " goes to Jail (test function)" strcat tellplayers
    GoToJail
    HandleLanding
    exit
  then
 
  dup "rent" stringcmp not if
    ( Test the rent function - hardcode to boardwalk )
    40 GetActualRent
    intostr "Got a rent of $" swap strcat tellme
    exit
  then

  dup "chance" stringcmp not if
    ( Test Chance )
	me @ "Location" MakePlayerProp "" 8 addprop
	HandleLanding
	exit
  then

  dup "commchest" stringcmp not if
    ( Test Community Chest )
	me @ "Location" MakePlayerProp "" 3 addprop
	HandleLanding
	exit
  then
 
  ( Walk around the board )
  1
  begin
    dup 40 <= while
        dup DrawSquare
        "-- Press Any Key then Enter for Next ('d' for deed) --" tellme
        read
        dup "d" stringcmp not if pop dup PrintADeed read then
        "q" stringcmp not if break then
        1 +
  repeat
  "** DONE **" tellme
;

( Main entry point and command dispatcher )
: main ( s -- )
  ( check the argument for install )
  dup "#install" stringcmp not if pop me @ owner prog owner dbcmp if doinstall then exit then
 
  ( Set up defaults )
  0 RentPenalty !
  0 ForceNextTurn !
  
  dup "#feep" stringcmp not if pop dofeep exit then
  dup "-greets" stringcmp not if pop dofeep exit then
  command @ "test" stringcmp not if me @ owner prog owner dbcmp if dotest then exit then
 
  ( lock the current game to prevent data inconsistency errors )
  ( if you don't have a current game, then it doesn't lock )
  lockgame

  ( all right.. what are we doing here? )
  command @ "new" stringcmp not if donew unlockgame exit then
  command @ "start" stringcmp not if pop dostart unlockgame exit then
  command @ "join" stringcmp not if dojoin unlockgame exit then
  command @ "leave" stringcmp not if pop doleave unlockgame exit then
  command @ "watch" stringcmp not if dowatch unlockgame exit then
  command @ "game" stringcmp not if dogame unlockgame exit then
  command @ "deed" stringcmp not if dodeed unlockgame exit then
  command @ "board" stringcmp not if doboard unlockgame exit then
  command @ "status" stringcmp not if dostatus unlockgame exit then
  command @ "scores" stringcmp not if doscores unlockgame exit then
  command @ "feep" stringcmp not if pop dofeep unlockgame exit then
 
  me @ "PlayingIn" GetPlayerStr "" strcmp not if
    "* You must first join a game with 'join <#>'" tellme
    "* You can see who is in a specific game with 'game <name>'" tellme
    unlockgame exit
  then
 
  "Started" GetGameStr "1" strcmp if
    "* The game has not yet started! The host must start the game with 'start'" tellme
    unlockgame exit
  then
 
  ( These commands are not valid until you are playing )
  command @ "roll" stringcmp not if pop doroll unlockgame exit then
  command @ "trade" stringcmp not if dotrade unlockgame exit then
  command @ "untrade" stringcmp not if dountrade unlockgame exit then
  command @ "accept" stringcmp not if doaccept unlockgame exit then
  command @ "reject" stringcmp not if doreject unlockgame exit then
  command @ "purchase" stringcmp not if pop dopurchase unlockgame exit then
  command @ "pass" stringcmp not if pop dopass unlockgame exit then
  command @ "buy" stringcmp not if dobuy unlockgame exit then
  command @ "sell" stringcmp not if dosell unlockgame exit then
  command @ "mortgage" stringcmp not if domortgage unlockgame exit then
  command @ "unmortgage" stringcmp not if dounmortgage unlockgame exit then
  command @ "portfolio" stringcmp not if pop doportfolio unlockgame exit then
  command @ "trading" stringcmp not if pop dotrading unlockgame exit then
  command @ "drop" stringcmp not if dodrop unlockgame exit then 
  command @ "bail" stringcmp not if pop dobail unlockgame exit then
  command @ "card" stringcmp not if pop docard unlockgame exit then
  command @ "retire" stringcmp not if pop doretire unlockgame exit then

  unlockgame
 
  me @ owner prog owner dbcmp if
    "Use #install to setup MUFopoloy in this room." tellme
  then
 
  "* Request not recognized" tellme
 
  pop
  
;
 
( Needed because we've got forward references )
public CommunityChest
public Chance
