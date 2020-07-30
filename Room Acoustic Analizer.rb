
# Written by Victor Leao. Don't forget to give me the credits if you use this code.
# The aim of this code is to analyze the acoustic of a room. I hope you enjoy. =D

print "ROOM ACOUSTIC ANALYZER
ver. 1.73 alpha

Insert the length, width and height of the room and the average temperature (use commas to separate):"

# INPUT
i=gets.chomp

if i=="help" || i=="?" || i=="info"
print "\n
Written by Victor Leao.
version 1.72 alpha

Instructions:
Floor area:
Total surface:
Total volume:
Average temperature:
Sound speed:
Max. dis. for phasing:
Max. dis. for flutter:
Min. dis. for echo:
Ratio:
Multiple measurements:
Square?:
Cubic?:
Optimum ratio?:
Golden ratio?:
Standard ratio?:
Phase level:
Flutter level:
Echo level:
Reverb level:
Reverb time:
Modes:
Schroeder\'s frequency:
Lower boundary:
Bonello\'s criterion?:
Fibonacci/Lucas?:
Standing music notes:
Scores:"
exit
end

puts i, "\n"
i=i.split(",")
l=i[0].to_f # length
w=i[1].to_f # width
h=i[2].to_f # height
t=i[3].to_f # temperature
values=[l, w, h].sort
values.freeze

# BASICS
area=l*w # floor area
surf=((area)+(w*h)+(l*h))*2 # total surface
vol=l*w*h # volume
ratio=[1.00, values[1]/values[0], values[2]/values[0]] # ratio
iso=[25, 31.5, 40, 50, 63, 80, 100, 125, 160, 200, 250, 315]
iso.freeze # ISO bands
fn=[130.81,138.59,146.83,155.56,164.81,174.61,185.00,196.00,207.65,220.00,233.08,246.94] # notes
fn.freeze # frequencies of notes
PHI=[0.61803398875, 1.61803398875, 2.61803398875]
PHI.freeze # PHI number
fib=[[1,1,2,3,5,8,13,21,34,55,89,144], [0,1,3,4,7,11,18,29,47,76,123,199], [1,3,4,7,11,18,29,47,76,123,199,322]]
fib.freeze

# PARAMETERS
if i[3]==nil # nil temperature
ss=344
t="-"
else
#ss=345.7 # test
ss=331.5*Math.sqrt(1+(t/273.15)) # sound speed
end
ed=(ss*0.045)/2 # echo distance
fl=(ss*0.03)/2 # flutter max
ph=(ss*0.005) # phasing distance
schro=3*ss/values.min #schroeder
lower=(ss/2)*Math.sqrt((1/values.max)**2)

# SETTINGS
var=0.30001 # variation range
varn=var*16 # var for notes
abs=0.2 # absortion for reverb time

# PRINTING
print "GENERAL
Length: #{l} m
Width: #{w} m
Height: #{h} m
Floor area: #{area.round(2)} m2
Total surface: #{surf.round(2)} m2
Total volume: #{vol.round(2)} m3
Average temperature: #{t} C
Sound speed: #{ss.round(2)} m/s
Max. dis. for phasing: #{ph.round(2)} m
Max. dis. for flutter: #{fl.round(2)} m
Min. dis. for echo: #{ed.round(2)} m\n"

# SQUARES
sqr=false # square
cub=false # cubic
sqr=true if (l-w>=0-var && l-w<=0+var) || (w-h>=0-var && w-h<=0+var) || (h-l>=0-var && h-l<=0+var)
cub=true if (l-w>=0-var && l-w<=0+var) && (w-h>=0-var && w-h<=0+var) && (h-l>=0-var && h-l<=0+var)

# MULTIPLES
mult=0
if (l+var)%w<=var || l%w<=var || (w+var)%l<=var || w%l<=var
mult+=1
lwm=true
end
if (w+var)%h<=var || w%h<=var || (h+var)%w<=var || h%w<=var
mult+=1
whm=true
end
if (h+var)%l<=var || h%l<=var || (l+var)%h<=var || l%h<=var
mult+=1
hlm=true
end

# RATIOS
opt=false # optimum ratios
if values[1]>=values[0]*2.16 && values[1]<=values[0]*2.22
if values[1]<=values[0]*2.16
#2.16
opt=true if values[2]>=values[0]*2.96 && values[2]<=values[0]*2.98
elsif values[1]<=values[0]*2.17
#2.17
opt=true if values[2]>=values[0]*2.96 && values[2]<=values[0]*2.99
elsif values[1]<=values[0]*2.18
#2.18
opt=true if values[2]>=values[0]*2.97 && values[2]<=values[0]*3.00
elsif values[1]<=values[0]*2.19
#2.19
opt=true if values[2]>=values[0]*2.99 && values[2]<=values[0]*3.02
elsif values[1]<=values[0]*2.20
#2.20
opt=true if values[2]>=values[0]*3.01 && values[2]<=values[0]*3.03
elsif values[1]<=values[0]*2.21
#2.21
opt=true if values[2]>=values[0]*3.02 && values[2]<=values[0]*3.03
elsif values[1]<=values[0]*2.22
#2.22
opt=true if values[2]>=values[0]*3.03 && values[2]<=values[0]*3.04
end
end
gr=0 # golden ratios
golden=false
gr+=1 if values[1]>=(values[0]*PHI[1])-(var/2) && values[1]<=(values[0]*PHI[1])+(var/2)
gr+=1 if values[2]>=(values[0]*PHI[2])-(var/2) && values[2]<=(values[0]*PHI[2])+(var/2)
gr+=1 if values[2]>=(values[1]*PHI[1])-(var/2) && values[2]<=(values[1]*PHI[1])+(var/2)
golden=true if gr>0
std=false # standard ratios
std=true if (values[1]>=values[0]*1.1 && values[1]<=values[0]*1.9) && (values[2]>=values[1]*1.1 && values[2]<=values[1]*1.45) && (values[2]<=values[0]*1.9 || values[2]>=values[0]*2.1)

# REFLECTIONS
phase=0 # phasing level
phase+=ph/l if l<=ph
phase+=ph/w if w<=ph
phase+=ph/h if h<=ph
flutter=0 # flutter echoes
flutter+=fl/l if l>ph && l<=fl
flutter+=fl/w if w>ph && w<=fl
flutter+=fl/h if h>ph && h<=fl
echoe=0 # echoing level
echoe+=l/ed if l>=ed
echoe+=w/ed if w>=ed
echoe+=h/ed if h>=ed
rt=(PHI[0]*vol)/(surf*abs) #reverb time

# MODES
bands={:"25"=>0, :"31.5"=>0, :"40"=>0, :"50"=>0, :"63"=>0, :"80"=>0, :"100"=>0, :"125"=>0, :"160"=>0, :"200"=>0, :"250"=>0, :"315"=>0}
cmodes=bands.dup # coincident modes
modald=bands.dup # modal density
abands=bands.dup # all bands' modes
modes={:a=>[], :t=>[], :o=>[]}
for f1 in 0..100 #for length
break if (ss/2)*Math.sqrt((f1/l)**2+(0/w)**2+(0/h)**2)>355
for f2 in 0..100 # width
break if (ss/2)*Math.sqrt((f1/l)**2+(f2/w)**2+(0/h)**2)>355
for f3 in 0..100 # height
next if f1==0 && f2==0 && f3==0
mode=(ss/2)*Math.sqrt((f1/l)**2+(f2/w)**2+(f3/h)**2)
next if mode<22.4
break if mode>355
nr=0
nr+=1 if f1>0 #reflec. number
nr+=1 if f2>0
nr+=1 if f3>0
#print f1, " ", f2, " ", f3, " - ", mode.round(2)
case nr
when 1 # axial mode
modes[:a]<<mode
#print " (axial)\n"
when 2 # tangential
modes[:t]<<mode
#print " (tangential)\n"
when 3 # oblique
modes[:o]<<mode
#print " (oblique)\n"
end
end
end
end
modes[:a].sort!
modes[:t].sort!
modes[:o].sort!
modes.freeze
# classifying relative modes
modes[:a].each do |fb| # axial
case fb
when (22.4...28.1)
bands[:"25"]+=1
when (28.1...35.5)
bands[:"31.5"]+=1
when (35.5...44.7)
bands[:"40"]+=1
when (44.7...56.1)
bands[:"50"]+=1
when (56.1...70.7)
bands[:"63"]+=1
when (70.7...89.1)
bands[:"80"]+=1
when (89.1...112)
bands[:"100"]+=1
when (112...141)
bands[:"125"]+=1
when (141...179)
bands[:"160"]+=1
when (179...224)
bands[:"200"]+=1
when (224...281)
bands[:"250"]+=1
when (281..355)
bands[:"315"]+=1
end
end
modes[:t].each do |fb| # tang
case fb
when (22.4...28.1)
bands[:"25"]+=0.5
when (28.1...35.5)
bands[:"31.5"]+=0.5
when (35.5...44.7)
bands[:"40"]+=0.5
when (44.7...56.1)
bands[:"50"]+=0.5
when (56.1...70.7)
bands[:"63"]+=0.5
when (70.7...89.1)
bands[:"80"]+=0.5
when (89.1...112)
bands[:"100"]+=0.5
when (112...141)
bands[:"125"]+=0.5
when (141...179)
bands[:"160"]+=0.5
when (179...224)
bands[:"200"]+=0.5
when (224...281)
bands[:"250"]+=0.5
when (281..355)
bands[:"315"]+=0.5
end
end
modes[:o].each do |fb| # obliq
case fb
when (22.4...28.1)
bands[:"25"]+=0.25
when (28.1...35.5)
bands[:"31.5"]+=0.25
when (35.5...44.7)
bands[:"40"]+=0.25
when (44.7...56.1)
bands[:"50"]+=0.25
when (56.1...70.7)
bands[:"63"]+=0.25
when (70.7...89.1)
bands[:"80"]+=0.25
when (89.1...112)
bands[:"100"]+=0.25
when (112...141)
bands[:"125"]+=0.25
when (141...179)
bands[:"160"]+=0.25
when (179...224)
bands[:"200"]+=0.25
when (224...281)
bands[:"250"]+=0.25
when (281..355)
bands[:"315"]+=0.25
end
end
bands.freeze
# classifying absolute modes
allmodes=(modes[:a]+modes[:t]+modes[:o]).sort
allmodes.freeze
allmodes.each do |fb| # obliq
case fb
when (22.4...28.1)
abands[:"25"]+=1
when (28.1...35.5)
abands[:"31.5"]+=1
when (35.5...44.7)
abands[:"40"]+=1
when (44.7...56.1)
abands[:"50"]+=1
when (56.1...70.7)
abands[:"63"]+=1
when (70.7...89.1)
abands[:"80"]+=1
when (89.1...112)
abands[:"100"]+=1
when (112...141)
abands[:"125"]+=1
when (141...179)
abands[:"160"]+=1
when (179...224)
abands[:"200"]+=1
when (224...281)
abands[:"250"]+=1
when (281..355)
abands[:"315"]+=1
end
end
abands.freeze
nm=1 # next mode
allmodes[0..-2].each do |cm| # coincidents
if cm==(allmodes[nm].to_f)
case cm
when (22.4...28.1)
cmodes[:"25"]+=1
when (28.1...35.5)
cmodes[:"31.5"]+=1
when (35.5...44.7)
cmodes[:"40"]+=1
when (44.7...56.1)
cmodes[:"50"]+=1
when (56.1...70.7)
cmodes[:"63"]+=1
when (70.7...89.1)
cmodes[:"80"]+=1
when (89.1...112)
cmodes[:"100"]+=1
when (112...141)
cmodes[:"125"]+=1
when (141...179)
cmodes[:"160"]+=1
when (179...224)
cmodes[:"200"]+=1
when (224...281)
cmodes[:"250"]+=1
when (281..355)
cmodes[:"315"]+=1
end
end
nm+=1
end
totalc=0 # total number of coincidents
for x in 0..11
break if iso[x]>schro
totalc+=cmodes.values[x]
end
# calculating modal density
isox=0
(bands.keys).each do |band|
modald[band]=bands[band]/iso[isox].to_f
isox+=1
end
smd=0 # modal density score
for md in (0..10)
break if iso[md+1]>schro
curve=iso[md+1].to_f*0.0003
if modald.values[md+1]-modald.values[md]>0 && modald.values[md+1]-modald.values[md]<=curve
smd+=2
elsif modald.values[md+1]-modald.values[md]>curve
smd-=(modald.values[md+1]-modald.values[md]-curve)*200
elsif modald.values[md+1]-modald.values[md]<0
smd-=(modald.values[md]-modald.values[md+1])*150
end
end
# checking Bonellos criterion
bonello=false
bsum=0
for x in 0..10
break if iso[x+1]>schro
bsum-=1 if abands.values[x+1]-abands.values[x]<0
end
for x in 0..11
break if iso[x]>schro
bsum-=1 if cmodes.values[x]>2
bsum-=1 if cmodes.values[x]==2 && abands.values[x]<5
end
bonello=true if bsum==0
# checking modes per band sequence
if abands.values==fib[0] || abands.values==fib[1] || abands.values==fib[2]
fibonacci=true
else
fibonacci=false
end

# STANDING NOTES
notes=0
for x in 0..2 # measures
for y in 0..11 # notes
notes+=1 if (ss/values[x]+varn)%fn[y]<=varn || (ss/values[x])%fn[y]<=varn || (fn[y]+varn)%(ss/values[x])<=varn || fn[y]%(ss/values[x])<=varn
end
end

# PRINTING
print "\nRATIO
Ratio: #{ratio[0].round(2)}/#{ratio[1].round(2)}/#{ratio[2].round(2)}
Multiple measurements: #{mult}\n"
print " -Length and width\n" if lwm==true
print " -Width and height\n" if whm==true
print " -Length and height\n" if hlm==true
print "Square? ", sqr, "\n"
print "Cubic? ", cub, "\n"
print "Optimum ratio? #{opt}
Golden ratio? #{golden}
Standard ratio? #{std}\n"
print "\nREFLECTIONS
Phase level: #{(phase*100).round}%
Flutter level: #{(flutter*50).round}%
Echo level: #{(echoe*50).round}%\n"
print "Reverb level: #{(rt*50).round}%
Reverb time (0.2 abs): #{rt.round(1)} sec\n"
puts "\nMODES
Absolute/Relative/Density/Coincidents"
for p in (0..11)
print " #{iso[p]} Hz: #{abands.values[p]} / #{bands.values[p]} / #{modald.values[p].round(3)} / #{cmodes.values[p]}\n"
end
puts "Schroeder\'s frequency: #{schro.round(2)} Hz
Lower boundary: #{lower.round(1)} Hz
Bonello\'s criterion? #{bonello}
Fibonacci/Lucas? #{fibonacci}"
puts "Standing music notes: #{notes}"

# EVALUATION
ratios=100-(mult*20) # ratio score
ratios-=10 if (values[1]>values[0]*1.9 && values[1]<values[0]*2.1) || (values[2]>values[1]*1.9 && values[2]<values[1]*2.1) || (values[2]>values[0]*1.9 && values[2]<values[0]*2.1)
ratios-=30 if sqr==true
ratios-=20 if cub==true
ratios+=20 if opt==true
ratios=0 if ratios<0
ratios=100 if ratios>100
reflecs=100-(phase*30)-((flutter-0.5)*30)-((echoe-1)*10)-(rt-3)
reflecs=100 if reflecs>100
reflecs=0 if reflecs<0
modals=60+(smd*1.5)-((schro-150)/10) # modal score
if bonello==true
modals+=23
else
modals+=bsum
end
modals=0 if modals<0
modals=100 if modals>100
music=100-(notes*5)-(totalc*2)-(lower-20)
music=0 if music<0
music=100 if music>100
score=((modals*2.5)+(ratios*0.5)+(reflecs*0.5)+(music*0.5))/4
score=100 if score>100
score=0 if score<0

print "\nSCORES
Modal: #{modals.round}
Musical: #{music.round}
Ratio: #{ratios.round}
Reflections: #{reflecs.round}
\nFINAL SCORE: #{score.round}"

