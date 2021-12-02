PL/SQL Developer Test script 3.0
16
--clear screen
--set serveroutput on size unlimited

declare
begin
  logger.set_level(p_level => 'ERROR');
  for indx in 1 .. 100 loop
    logger.log(p_text => 'Debug message '||to_char(indx), p_scope => 'Anonymous'); 
    logger.log_information(p_text => 'Information message '||to_char(indx), p_scope => 'Anonymous'); 
    logger.log_warning(p_text => 'Warning message '||to_char(indx), p_scope => 'Anonymous'); 
  end loop;
  logger.log_error(p_text => 'An error '||to_char(systimestamp, 'YYYY-MM-DD HH24:MI:SS.FF6')
                  ,p_scope => 'Anonymous'
                  );
end;
--/
0
0
