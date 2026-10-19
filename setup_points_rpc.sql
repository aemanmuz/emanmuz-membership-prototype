-- Run this in Supabase SQL Editor AFTER the initial tables/policies have been created.
-- This ensures point changes and their history are recorded in one database transaction.

create or replace function public.adjust_member_points(
  p_member_id uuid,
  p_change integer,
  p_reason text
)
returns integer
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_balance integer;
begin
  if not public.is_admin() then
    raise exception 'Admin access required';
  end if;

  if p_change is null or p_change = 0 then
    raise exception 'Points change must not be zero';
  end if;

  if p_reason is null or length(trim(p_reason)) = 0 then
    raise exception 'Please provide a reason for the points adjustment';
  end if;

  update public.members
  set points_balance = points_balance + p_change,
      updated_at = now()
  where id = p_member_id
    and points_balance + p_change >= 0
  returning points_balance into v_balance;

  if v_balance is null then
    if not exists (select 1 from public.members where id = p_member_id) then
      raise exception 'Member not found';
    end if;
    raise exception 'Points balance cannot be negative';
  end if;

  insert into public.points_transactions
    (member_id, points_change, reason, created_by)
  values
    (p_member_id, p_change, trim(p_reason), auth.uid());

  return v_balance;
end;
$$;

revoke all on function public.adjust_member_points(uuid, integer, text) from public, anon;
grant execute on function public.adjust_member_points(uuid, integer, text) to authenticated;
