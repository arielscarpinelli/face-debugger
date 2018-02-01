#  ARFaceAnchor.BlendShapeLocation Debugger

This is a simple app to show you all the detected face coefficients with the TrueDepth camera in a graphical way. I made it so I could try to make sense of all the numbers by simply playing with my facial expressions.

![screenshot](https://raw.githubusercontent.com/arielscarpinelli/face-debugger/master/screenshot.jpg "Screenshot")

It shows your face along with a bar chart underneath, where every bar is one of the coefficients obtained in blendShapes dictionary of the ARFaceAnchor object. The idea is to locate the bars somewhat aligned vertically near the location of your face that should be affecting that coefficent. Of course is far from ideal, but gives you an idea of how the coefficients move along with your facial features.



