FUNCTION Construct_DataPaths, lower, upper, job, totaljobs

  ; Sanity checking
  IF N_ELEMENTS(lower) EQ 0 THEN lower = 0
  IF N_ELEMENTS(upper) EQ 0 THEN upper = 0
  
  ; If either of the banks are -ve, then ignore
  IF (lower LT 0) THEN lower = 0
  IF (upper LT 0) THEN upper = 0
  
  ; Work out what the lower/upper are for this jo

  IF (lower NE 0) AND (upper NE 0) THEN BEGIN
    IF (totaljobs EQ 1) THEN BEGIN
      this_lower = lower
      this_upper = upper
    ENDIF ELSE BEGIN
      banks_per_job = ceil(float((upper - lower + 1)) / TotalJobs)
      ;print, (upper - lower + 1)
      print, banks_per_job, TotalJobs
      this_lower = ceil((job-1)*banks_per_job)+1
      this_upper = ceil(job*banks_per_job)
      IF (this_upper GT upper) THEN this_upper = upper
      IF (job EQ TotalJobs) THEN this_upper = upper
    ENDELSE
    datapaths=STRCOMPRESS(STRING(this_lower), /REMOVE_ALL) + "-" $
        + STRCOMPRESS(STRING(this_upper), /REMOVE_ALL)
    RETURN, datapaths
  ENDIF
  
  IF (lower NE 0) AND (upper EQ 0) THEN BEGIN
    RETURN, STRING(STRCOMPRESS(lower, /REMOVE_ALL))
  ENDIF
  
  IF (lower EQ 0) AND (upper NE 0) THEN BEGIN
    RETURN, STRING(STRCOMPRESS(upper, /REMOVE_ALL))
  ENDIF

  RETURN, ""
 
END
