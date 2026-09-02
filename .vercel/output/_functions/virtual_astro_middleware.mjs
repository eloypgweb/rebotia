import { ot as defineMiddleware, t as sequence } from "./chunks/sequence_Cw2Njjgx.mjs";
import { createServerClient, parseCookieHeader } from "@supabase/ssr";
//#region src/middleware.ts
var onRequest$1 = defineMiddleware(async (context, next) => {
	const supabase = createServerClient("https://sdpbuhjhsqbubchfoyyt.supabase.co", "sb_publishable_RERelxk5mzEVPeZaJsgyAg_KxLkBVSj", { cookies: {
		getAll() {
			return parseCookieHeader(context.request.headers.get("Cookie") ?? "");
		},
		setAll(cookiesToSet) {
			cookiesToSet.forEach(({ name, value, options }) => context.cookies.set(name, value, options));
		}
	} });
	context.locals.supabase = supabase;
	const { data: { user } } = await supabase.auth.getUser();
	context.locals.user = user;
	context.locals.perfil = null;
	if (user) {
		const { data: perfil } = await supabase.from("perfiles").select("nombre, rol").eq("id", user.id).single();
		context.locals.perfil = perfil;
	}
	if (context.url.pathname.startsWith("/coach")) {
		if (!user) return context.redirect("/login");
		if (context.locals.perfil?.rol !== "admin" && context.locals.perfil?.rol !== "editor") return context.redirect("/no-autorizado");
	}
	if (context.url.pathname.startsWith("/perfil") && !user) return context.redirect("/login");
	return next();
});
//#endregion
//#region \0virtual:astro:middleware
var onRequest = sequence(onRequest$1);
//#endregion
export { onRequest };
