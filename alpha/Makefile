all: part1.gcode part2.gcode part3.gcode

SLIC3R=--load ~/Desktop/new-abs/config_ABS300_20140706.ini --solid-infill-every-layers 1 --support-material

%.gcode: %.stl
	slic3r ${SLIC3R} -o $@ $<

%.svg: %.stl
	slic3r ${SLIC3R} --export-svg $<

%.stl: %.scad object.stl
	openscad -o $@ $<

clean:
	rm *.3ds *.mtl *.obj *.stl *.gcode *.svg
