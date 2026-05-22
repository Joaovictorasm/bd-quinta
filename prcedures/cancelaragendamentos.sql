create or replace procedure cancelar_agendamento(p_id integer)
language plpgsql
as $$
begin
    
    if not exists (select 1 from agendamentos where id = p_id) then 
        raise exception 'Agendamento ID=% não encontrado!', p_id;
    end if;
    
    if exists (select 1 from agendamentos where id = p_id and status = 'cancelado') then 
        raise exception 'Agendamento ID=% já está cancelado!', p_id;
    end if;
    
    update agendamentos
    set status = 'cancelado'
    where id = p_id;
    
    raise notice 'Agendamento ID=% cancelado com sucesso!', p_id;
end; 
