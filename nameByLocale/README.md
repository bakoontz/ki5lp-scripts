# Transform repeater location to call data fields, optionally sorts by
# location and/or applies offset to numeric location.  Data format
# read is specific to the CHIRP format of the online RepeaterBook
# (http://www.repeaterbook.com) as specified below.  Disclaimer: I
# have no affiliation with the RepeaterBook website.
#
# Usage: nameByLocale.pl [-s] [-o memory_offset] -f filename.csv
#
#     where:
#		-f <filename> specifies the input filename (required)
#		-s specifies output sort by locale (optional)
#		-o <offset> specifies starting location offset (optional)
#       -h this help
#
# Input data format: 
#
# Location,Name,Frequency,Duplex,Offset,Tone,rToneFreq,cToneFreq,DtcsCode,DtcsPolarity,Mode,TStep,Comment
# 1,,144.50000,split,147.50000,Tone,107.2,88.5,023,NN,FM,5,"Butte", 
#
# Copyright 2014 Brian Koontz <kz5q@qsl.net>.
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# 
#
#####################################################################
