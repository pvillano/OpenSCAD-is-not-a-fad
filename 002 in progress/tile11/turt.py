from turtle import *
color('red', 'yellow')
begin_fill()
x=60
y=60
left(90)
for a in [0,x,-90,y,90,x,-90,y,90,-y,90,-x,90,x]:
    forward(100)
    left(a)
end_fill()
done()