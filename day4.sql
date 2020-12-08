create or replace function seatrange (p_seat in varchar2, p_min number, p_max number) return number is   
  v_seat varchar2(1):=substr(p_seat,1,1);   
  v_rest varchar2(7):=substr(p_seat,2);   
  v_min number;   
  v_max number;   
  v_result number;  
  v_dist number := p_max - p_min;
begin   
 
--if length(p_seat) = 1 then  
-- return p_max;  
-- r-eturn p_max;  
-- - end if;  
  if v_dist = 1 then   
    if v_seat in ('F', 'L') then  
      v_result := p_min;  
    else   
      v_result := p_max ;  
    end if ;  
    return v_result;  
  else   
    if v_seat in ('F', 'L') then   
      v_min := p_min;   
      v_max := p_min + floor( v_dist / 2);  
    else   
      v_min := p_min + ceil(v_dist / 2);   
      v_max := p_max;   
    end if;   
    --dbms_output.put_line('letter ' ||v_seat ||' min :' ||v_min||' max:'||v_max||' dist:' ||v_dist) ;  
    return (seatrange(v_rest,v_min, v_max)) ;   
  end if;   
end; 
/
With
Seats as (select 'FBFBBFFRLR' seat from dual) 
Select max(seatrange(substr(seat,1,7),0,127)* 8 +seatrange(substr(seat,8),0,7)) tickets from seats
