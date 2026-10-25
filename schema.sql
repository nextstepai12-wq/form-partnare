create table if not exists rt_applications(
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz default now(),
  team_name text not null check (char_length(team_name) <= 120),
  members text not null check (char_length(members) <= 1500),
  leader_name text not null check (char_length(leader_name) <= 120),
  phone text not null check (char_length(phone) <= 30),
  email text not null check (char_length(email) <= 160),
  platform_url text not null check (char_length(platform_url) <= 300),
  linkedin_url text not null check (char_length(linkedin_url) <= 300),
  why_join text not null check (char_length(why_join) <= 2000),
  goals text not null check (char_length(goals) <= 2000),
  collab_ideas text check (char_length(collab_ideas) <= 2000),
  consent boolean not null check (consent),
  status text not null default 'new' check (status in ('new','reviewing','accepted','declined')));
create unique index if not exists rt_app_email on rt_applications (lower(email));

create table if not exists rt_settings(
  id int primary key default 1 check (id = 1), meeting_at timestamptz, place text);
create table if not exists rt_private(
  id int primary key default 1 check (id = 1), invite_link text);
insert into rt_settings(id) values (1) on conflict do nothing;
insert into rt_private(id) values (1) on conflict do nothing;

alter table rt_applications enable row level security;
alter table rt_settings enable row level security;
alter table rt_private enable row level security;

create policy "public apply" on rt_applications for insert to anon with check (status = 'new');
create policy "admin applications" on rt_applications for all to authenticated using (true) with check (true);
create policy "public read settings" on rt_settings for select to anon, authenticated using (true);
create policy "admin settings" on rt_settings for all to authenticated using (true) with check (true);
create policy "admin private" on rt_private for all to authenticated using (true) with check (true);
