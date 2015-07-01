EasyPin 006

#What does the program do

This MAXScript in combination with the corresponding 3dsmax and openFrameworks app allows to establish a connection via TCP between the two. Created 3D contend can then be send directly to either the inFORM or the TRANSFORM.


#How to use the program

For the inFORM open EasyPin_006_inFORM_30x30px.max and under MAXScript menu > MAXScript > Run Script select EasyPin_006_inFORM or for the TRANSFORM open EasyPin_006_TRANSFORM_102x24px.max and load EasyPin_006_TRANSFORM.ms

Then press Ctrl + E to evaluate (run) the script. The EasyPin window should pop up. If the corresponding OF app is running you can click on "start Client". This will establish the TCP connection. 

Now you can create 3d content within the bounding box in you see in the 3dsmax window. Pressing "send Ray Data" will display this geometry on the shape display.

If you create an animation in 3dsmax and you want to send it to the shape display you need to check the auto update check box. Now if you play back the animation every single frame will be send to the shape display and is buffered. This can happen in real time or sometimes really slow (I have not yet figures out the cause of this).  
You can then playback the animation within the OF application (see instructions in the corresponding app README).

Instead of just quitting either application make sure to hit "stop Client" in the EasyPin window first. If you don't you might get an error the next time you try to establish a connection. If that happens you need to change the connection port in both applications. I'm not sure why that happens but I guess that the port will just remain open and cannot be reassigned.

The script has only been tested with 3dsMax 2014 but newer versions should also work just fine.

#-----------------------------

#How to Render and Preview

##Render depth maps (hail to the weirdness of 3dsmax):
To render the greyscale maps I do not use the normal depth shader but a trick that lets me render the depth map in othographic view.
Go to Rendering -> Environment and Effects. Click on the Effects tab and select File Output in the Effects list.
Under file Output Parameters you can set the path where your single image or sequence of images should be saved. Under Parameters you can see that we manually set the near and far z clipping planes to be 10 units apart. So everything withing the clipping planes will be mapped to a value that is between completely white (255) or completely black (0).
Be aware that this is a seperate render pass which is independent from your normal render taks.

Now you need to hit C to set the current view to be the camera. Then hit shift + F to show you your render output aspect ratio.

You can now hit Render and the greyscale images will be saved in the predetermined location. If you render an image sequence you might get an error saying that all frames might be lost. Continue anyway. This is because we the normal render pass will render the color images but we don't care about them. The depth pass will save the images anyway to the path we determined above.

##Testing greyscale images and video within 3dsmax
I set up a "test rig" within 3dsmax that let's you test/visualize what your greyscale image would look like on the shape display. You have to select the object "PinHeightChanger". It is the plane to which all pins are connected. This plane has a displacement map assigned to it. You can change the map withing the objects parameters or using the maps instance in the Material Editor.