emanmuz Membership Prototype — setup notes

1. In Supabase SQL Editor, run setup_points_rpc.sql after your existing schema and admin account are set up.
2. Open index.html in VS Code.
3. Find this line:
   const SUPABASE_PUBLISHABLE_KEY = 'PASTE_YOUR_SUPABASE_PUBLISHABLE_KEY_HERE';
   Replace the placeholder with your Supabase publishable key. Keep the quotes.
4. Save index.html.
5. Test locally using the VS Code Live Server extension (recommended), or deploy to GitHub Pages.
6. In GitHub, open your aemanmuz/emanmuz.github.io repository and add/replace index.html with this file. Commit the change. GitHub Pages should publish it at https://aemanmuz.github.io/.

Security notes:
- Never put the Supabase service_role key or any secret key in this website.
- This app has no public sign-up form. Create admin users in Supabase Authentication and add their UUIDs to public.admin_users using the SQL Editor.
- Existing Row Level Security policies should remain enabled.
- This is a prototype; before using real customer data at scale, review privacy, backups, and operational access.
