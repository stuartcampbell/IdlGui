;****************************************************************
;******** HISTOGRAMMING API FOR IDL *****************************
;******** version with axis on the plot  ************************
;****************************************************************

; setting up a starting time

;file_name = "DAS_30_neutron_histo.dat"

;open file and check size
;file = "/Users/j35/TranslationService/trunk/prenexus/HistExample02/das_30/" + file_name

;**** pickup dialog box******************************************
 file = dialog_pickfile(/must_exist, $
 title='Select a binary file', $
 filter = ['*.dat'],$
 ;path = 'c:\Documents and Settings\j35\Desktop\HistoTool\DAS_3\DAS_event_1\', $
 path = "/Users/j35/CD4/BSS/",$
 get_path = path)
;****************************************************************

; to get only the last part of the name
file_list = strsplit(file,'\',/extract, count=length)
file_name = file_list[length-1]

openr,1,file
fs = fstat(1)
N=fs.size        ;size of file

Nbytes = 4       ;data are Uint32 = 4 bytes
N = fs.size/Nbytes
data = lonarr(N)
readu,1,data
;data = swap_endian(data)    ;swap endian because PC -> Mac
close,1            ;close file

;################################
;Nx = 256       ;information from xxx_runnumber_runinfo.xml
;Ny = 304
;Nt = 167
;Nt = 83
Nx=56L
Ny=128L
Nt=1
;#################################

;find the non-null elements
indx1 = where(data GT 0, Ngt0)
;img = intarr(Nt,Nx,Ny)
img=intarr(Nt,Ny,Nx)

img(indx1) = data(indx1)
simg = total(img,1)     ;sum over time bins

;format of graph
xtitle="pixel x"
ytitle="pixel y"
title=file_name
window,1,xsize=450,ysize=450,xpos=650,ypos=250

;***************color*************

do_color = 1

if do_color EQ 1 then begin

    ;Decomposed=0 causes the least-significant 8 bits of the color index value
    ;to be interpreted as a PseudoColor index.
    DEVICE, DECOMPOSED = 0

    ;pick your favorite color table...see xloadct
    loadct,5

endif

;*********end of color part***********************
xoff=100
yoff=80


tvscl, simg, xoff, yoff, /device,xsize=Nx,ysize=Ny     ;plot data

plot,[0,Nx],[0,Ny],/nodata,/device,xrange=[0,Nx], yrange=[0,Ny],ystyle=1,$
xstyle=1,pos=[xoff,yoff,xoff+Nx,yoff+Ny],$
/noerase,xtitle=xtitle, ytitle=ytitle,title=title, charsize=1.4,$
charthick=1.6
wshow

end_time = systime(1)

end
