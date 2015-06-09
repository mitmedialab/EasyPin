/*
EasyPin 006 for the TRANSFORM
Created by Philipp Schoessler
07.03.2014
MIT Media Lab 
Tangible Media Group
*/

(
local ip = "18.111.114.79"
local prt = 11996
local prtStr = prt as string
local pins  = #()
local sortedPins = #()
local allVerts = #()
local baseObj
local idx = 0
local bAnimate = false
local doEveryFrame -- empty variable so we can unregister callback function of same name (very weird but works)
	
local objToConsider = #()
local heightVals = #()
local changeHandlers =#()

try(destroyDialog myRollout) catch()
	
-----------------------------------------------------------
-- geometry ---------------------------------------------
-----------------------------------------------------------

fn updateChangeHandlers &obj &changeHandlers = 
(
	/*
	TO DO: implement callbacks to register when geometry is transformed
	fn printTest = (print "trans")
	updateTeapot = when transform $Teapot001 changes do printTest()
	*/
)

-----------------------------------------------------------

fn collisionDetection node1 node2 =
(
	if intersects node1 node2 then 
		true
	else
		false
)

-----------------------------------------------------------

fn rayFunction &obj = 
(
	returnArr = #()
	for j in obj do
	(
		--print j.name
		for i = 1 to getNumVerts $RaySender do
		(
			theDist = 0
			thePos = 0
			temp = getVert $RaySender i
			theIntersect = IntersectRay j (Ray temp [0,0,-1])
			
			if theIntersect != undefined then
			(
				if ( theDist = length (theIntersect.pos - temp)) > 10 then 10 else theDist
				if theDist != returnArr[i] then 
				(
					if returnArr[i] == undefined then
						returnArr[i] = theDist
					else if returnArr[i] > theDist then
						returnArr[i] = theDist
					--print i
					--print returnArr[i]
				)
			)
			else if theIntersect == undefined and returnArr[i] == undefined then
			(
				returnArr[i] = 10
			)
		)
	)
	free obj --empty referenced array
	return returnArr
)

-----------------------------------------------------------

fn generateRayData =
(
	returnArr = #()
	for obj in Geometry do
	(
		if obj.name != "ActionBox" and obj.name != "RaySender" and obj.name != "PinPlaneTemplate" do
		(
			isIn = collisionDetection obj $ActionBox
			if isIn == true do
				append objToConsider obj
		)
	)
	returnArr = rayFunction objToConsider
	return returnArr
)


-----------------------------------------------------------
-- protcol and data-------------------------------------
-----------------------------------------------------------

fn startClient ip_string port_int = 
(
	  global socket = dotNetObject "System.Net.Sockets.Socket" ( dotnetclass "System.Net.Sockets.AddressFamily" ).InterNetwork ( dotnetclass "System.Net.Sockets.SocketType" ).Stream ( dotnetclass "System.Net.Sockets.ProtocolType" ).Tcp
	  socket.Connect ip_string port_int
	  socket   -- return
)

-----------------------------------------------------------

fn map val inputMin inputMax outputMin outputMax clamp =
(
	outVal = ((val - inputMin) / (inputMax - inputMin) * (outputMax - outputMin) + outputMin)
	if clamp != 0 then
	(
		if outputMax < outputMin then
		(
			if outVal < outputMax then outVal = outputMax
			else if outVal > outputMin then outVal = outputMin 
		)
		else
		(
			if outVal > outputMax then outVal = outputMax
			else if outVal < outputMin then outVal = outputMin
		)
	)
	outVal = outVal as integer
	--print outVal
	outVal
)

-----------------------------------------------------------

fn send &obj = 
(
	--print "here"
	posStr = ""
	posArr = #()
	for i = 1 to getNumVerts obj do
	(
		temp = getVert obj i
		val = map temp.z 0 10 0 255 1
		append posArr val
		append posStr (posArr[i] as string)
		append posStr ","
	)
	append posStr "\n"
	ascii_encoder = dotNetObject "System.Text.ASCIIEncoding"
	bytes = ascii_encoder.GetBytes (posStr)
	result = socket.Send bytes
	--print result
	result  -- return # of bytes sent
)

-----------------------------------------------------------

fn sendMeshBytes &obj = 
(
	--print "here"
	--ascii_encoder = dotNetObject "System.Text.ASCIIEncoding"
	--bytes = ascii_encoder.GetBytes ("\n")
	posArr = #()
	for i = 1 to getNumVerts obj do
	(
		temp = getVert obj i
		val = map temp.z 0 10 0 255 1
		append posArr val
		--posArr[1] = val
		--result = socket.Send posArr
	)
	--myArr = #(124, 125)
	--intToByte = dotNetObject "System.Byte[]" 125
	--byte = sendInt as byte
	result = socket.Send posArr
	--print result
	--print posArr
	idx += 1
	--print idx
	ascii_encoder = dotNetObject "System.Text.ASCIIEncoding"
	bytes = ascii_encoder.GetBytes ("\n")
	result = socket.Send bytes
	result  -- return # of bytes sent
)

-----------------------------------------------------------

fn sendRayBytes = 
(
	vals = generateRayData()
	posArr = #()
	for i = 1 to vals.count do
	(
		--print myVal
		val = map vals[i] 0 10 0 255 1
		--print val
		append posArr val
		--posArr[1] = val
		--result = socket.Send posArr
	)
	--myArr = #(124, 125)
	--intToByte = dotNetObject "System.Byte[]" 125
	--byte = sendInt as byte
	result = socket.Send posArr
	--print result
	--print posArr
	idx += 1
	print idx
	ascii_encoder = dotNetObject "System.Text.ASCIIEncoding"
	bytes = ascii_encoder.GetBytes ("\n")
	result = socket.Send bytes
	result  -- return # of bytes sent
)


   
-----------------------------------------------------------
   
fn stopClient = 
(
	if socket != undefined then
	(
		socket.Close()
		socket = undefined
		print "connection closed"
	)
)
	
-----------------------------------------------------------	
	
fn test baseObject = 
(
	idx += 1 
	print idx
	--print "test fn"
	--print ip
	--print prt
	--for i = 1 to allVerts.count do print allVerts[i]
	posStr = ""
	posArr = #()
		for i = 1 to getNumVerts baseObject do
		(
			temp = getVert baseObject i
			val = map temp.z 0 10 0 255 1
			append posArr val
			--print posArr[i]
			append posStr (posArr[i] as string)
			append posStr ","
		)
		--print posStr
)

-----------------------------------------------------------
-- callback weirdnes -----------------------------------
-----------------------------------------------------------

fn doThis =
(
	--if baseObj != 0 then sendMeshBytes baseObj
	sendRayBytes()
)

fn doEveryFrame = 
(
	doThis()
)

-----------------------------------------------------------
-- rollout menu -----------------------------------------
-----------------------------------------------------------

rollout myRollout "EasyPin 006"
(
	group "TCP"
	(
		edittext txtIP "Server IP" text:"18.111.8.146"
		edittext txtPort "Port" text:prtStr
		checkbox cbAnimate "auto-update"
		button btnClientOn "start Client"
		button btnClientOff "stop Client"
		--button btnSendMeshData "send Mesh Data"
		button btnSendRayData "send Ray Data"
	)
	
	/*
	group "Base"
	(
			pickbutton pbtnGetPins "get Base Mesh"
			label lbl1 "-no object picked-"
	)
	*/
	
	group "Test"
	(
			button btnTest "Test"
	)
	
	on myRollout close do 
	(
		unregisterTimeCallback doEveryFrame
		print "time change unregistered"
	)
	
	on txtIP entered txt do
	(
		ip = txt
	)
	
	on txtPort entered txt do
	(
		prt = txt as integer
	)
	
	on cbAnimate changed theState do
	(
		bAnimate = theState
		if bAnimate == true then registerTimeCallback doEveryFrame
		else unregisterTimeCallback doEveryFrame
	)
	
	 on btnClientOn pressed do
	(
		startClient ip prt
		print "start Client"
	)
	
	 on btnClientOff pressed do
	(
		print "trying to stop connection ..."
		stopClient()
	)
	
	 on btnSendMeshData pressed do
	(
		if baseObj != undefined and socket != undefined then
		(
			sendMeshBytes baseObj
			print "send Mesh Data"
		)
		else
		(
			messagebox "cannot send data if client is not connected"
		)
	)
	
	 on btnSendRayData pressed do
	(
		if socket != undefined then
		(
			sendRayBytes()
			print "send Ray Data"
		)
		else
		(
			messagebox "cannot send data if client is not connected"
		)
	)
	
	on pbtnGetPins picked PickedObj do
	(
		if(classof PickedObj == Editable_mesh or classof PickedObj == Editable_poly) then
		(
			baseObj = PickedObj
			print baseObj.name
			lbl1.text = baseObj.name

			for i = 1 to getNumVerts baseObj do
			(
				allVerts[i] = baseObj.verts[i]
			)
		)
		else
		(
			messageBox "Object needs to be Editable Mesh or Editable Poly"
		)
	)
	
	on btnTest pressed do
	(
		print "test"
		testArr = generateRayData()
		print testArr
		--sendMeshBytes baseObj
	)
	
 )
 createDialog myRollout
 
-----------------------------------------------------------

)