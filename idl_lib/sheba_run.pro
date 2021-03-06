;==================================================================
;Copyright 2011, 2012  David Pérez-Suárez (TCD-HELIO)
;===================GNU license====================================
;This file is part of SHEBA.
;
;    SHEBA is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    SHEBA is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with SHEBA.  If not, see <http://www.gnu.org/licenses/>.
;==================================================================
pro sheba_back,$
   model=model,time_impact=time_impact,object=object,_extra=_extra,$;inputs
   time_sol=time_sol,solar_longitude=solar_longitude ;outputs

  if model eq 'cme' then prop_end_back,object=object,t0=time_impact,_extra=_extra
  if model eq 'sep' then prop_sep_back,object=object,t0=time_impact,_extra=_extra
  if model eq 'cir' then prop_cir_back,object=object,t0=time_impact,_extra=_extra
end
;...//////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\....
pro sheba_run,model=model,time_sol=time_sol,time_impact=time_impact,_extra=_extra
; to run CME model forward:
;sheba_run,model='cme',time_sol='2009/11/31T00:00:00',vel=1500,e_vel=100,width=20,x0=75,path_out='/tmp/sheba_test/cme01/'
; To run CME model backwars:
;sheba_run,model='cme',time_impact='2009/12/09T00:00:00',width=70,vel=2000,object='STEREOA',path_out='/tmp/sheba_test/cme01/'
;
; To run SEP model forward:
;sheba_run,model='sep',time_sol='2010-01-01T00:00',x0=65,vel=400,e_vel=40,beta=0.9,path_out='/tmp/test01/'
;
; To run SEP model backward:
;sheba_run,model='sep',time_impact='2010-01-01T00:00',object='Mars',vel=400,e_vel=40,beta=0.9,path_out='/tmp/test03/'
;
; To run CIR model forward:
;sheba_run,model='cir',time_sol='2010-01-01T00:00',x0=65,vel=600,e_vel=40,path_out='/tmp/test01/'
;
; To run CIR model backward:
;sheba_run,model='cir',time_impact='2010-01-01T00:00',object='Mercury',vel=600,e_vel=40,path_out='/tmp/test01/'

  
; run backwards model to get time_sun for each model if time_impact is provided
if n_elements(time_impact) gt 0 then begin
   sheba_back,model=model,time_impact=time_impact,_extra=_extra

endif else begin

;All the models need the coordinates from the planets and spacecraft
;===================================================================
;====================  Obtain properties of planets and spacecraft
   models = ['cme','sep','cir']
   dranges = [300,1,15]
   days_range =dranges[where(model eq models)]
   ellip = planet_orbit(time_sol,3,planet=earth,all_planets=all_planets)
   all_spacecraft  = spacecraft_path(time_sol,drange=days_range[0])



   if model eq 'cme' then $
      prop_end,planets_str=all_planets,spacecraft_str=all_spacecraft,t0=time_sol,_extra=_extra
   if model eq 'sep' then $
      prop_sep,planets_str=all_planets,spacecraft_str=all_spacecraft,t0=time_sol,_extra=_extra
   if model eq 'cir' then $
      prop_cir,planets_str=all_planets,spacecraft_str=all_spacecraft,t0=time_sol,_extra=_extra

endelse

end
