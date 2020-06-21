declare
  l_count pls_integer;
begin
  $if $$logger_no_op_install $then
    null;
  $else
    -- SEQUENCE
    select count(1)
    into l_count
    from user_sequences
    where sequence_name = 'LOGGER_APX_ITEMS_SEQ';

    if l_count = 0 then
      execute immediate '
        create sequence logger_apx_items_seq
            minvalue 1
            maxvalue 999999999999999999999999999
            start with 1
            increment by 1
            cache 20
      ';
    end if;
  $end
end;
/
