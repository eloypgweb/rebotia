import { t as __exportAll } from "./rolldown-runtime_D7D4PA-g.mjs";
import { O as renderTemplate, R as createAstro, S as renderComponent, k as maybeRenderHead } from "./sequence_Cw2Njjgx.mjs";
import { t as createComponent } from "./compiler_BEFu2b5Y.mjs";
import { n as renderScript, t as $$Layout } from "./Layout_f2732cNd.mjs";
//#region src/pages/login.astro
var login_exports = /* @__PURE__ */ __exportAll({
	default: () => $$Login,
	file: () => $$file,
	url: () => $$url
});
createAstro("https://astro.build");
var $$Login = createComponent(($$result, $$props, $$slots) => {
	const Astro = $$result.createAstro($$props, $$slots);
	Astro.self = $$Login;
	if (Astro.locals.user) return Astro.redirect("/");
	return renderTemplate`${renderComponent($$result, "Layout", $$Layout, { "title": "Iniciar sesión — Rebotia" }, { "default": async ($$result) => renderTemplate`${maybeRenderHead($$result)}<div class="mx-auto max-w-sm rounded-xl border border-club-blue/30 bg-white p-8 shadow-sm"><h1 class="text-2xl font-bold text-club-navy">Iniciar sesión</h1><p class="mt-1 text-sm text-club-navy/70">Introduce tu email y contraseña.</p><form id="login-form" class="mt-6 flex flex-col gap-4"><div class="flex flex-col gap-1"><label for="email" class="text-sm font-medium text-club-navy">Email</label><input id="email" name="email" type="email" required autocomplete="email" class="rounded-lg border border-club-blue/40 px-3 py-2 text-club-navy outline-none focus:border-club-blue focus:ring-2 focus:ring-club-blue/30"></div><div class="flex flex-col gap-1"><label for="password" class="text-sm font-medium text-club-navy">Contraseña</label><input id="password" name="password" type="password" required autocomplete="current-password" class="rounded-lg border border-club-blue/40 px-3 py-2 text-club-navy outline-none focus:border-club-blue focus:ring-2 focus:ring-club-blue/30"></div><button type="submit" class="mt-2 rounded-lg bg-club-navy px-4 py-2 font-semibold text-club-white transition-colors hover:bg-club-blue hover:text-club-navy disabled:cursor-not-allowed disabled:opacity-60">Entrar</button></form><p id="login-status" role="status" class="mt-4 text-sm text-club-navy/80"></p></div>${renderScript($$result, "C:/Users/USUARIO/Desktop/EloyProjects/rebotia/src/pages/login.astro?astro&type=script&index=0&lang.ts")}` })}`;
}, "C:/Users/USUARIO/Desktop/EloyProjects/rebotia/src/pages/login.astro", void 0);
var $$file = "C:/Users/USUARIO/Desktop/EloyProjects/rebotia/src/pages/login.astro";
var $$url = "/login";
//#endregion
//#region \0virtual:astro:page:src/pages/login@_@astro
var page = () => login_exports;
//#endregion
export { page };
