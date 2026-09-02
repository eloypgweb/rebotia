import { A as renderHead, C as Fragment, M as createRenderInstruction, O as renderTemplate, R as createAstro, S as renderComponent, T as renderSlot, j as addAttribute, k as maybeRenderHead } from "./sequence_Cw2Njjgx.mjs";
import { t as createComponent } from "./compiler_BEFu2b5Y.mjs";
//#region node_modules/astro/dist/runtime/server/render/script.js
async function renderScript(result, id) {
	const inlined = result.inlinedScripts.get(id);
	let content = "";
	if (inlined != null) {
		if (inlined) content = `<script type="module">${inlined}<\/script>`;
	} else {
		const resolved = await result.resolve(id);
		content = `<script type="module" src="${result.userAssetsBase ? (result.base === "/" ? "" : result.base) + result.userAssetsBase : ""}${resolved}"><\/script>`;
	}
	return createRenderInstruction({
		type: "script",
		id,
		content
	});
}
//#endregion
//#region src/components/Navbar.astro
createAstro("https://astro.build");
var $$Navbar = createComponent(($$result, $$props, $$slots) => {
	const Astro = $$result.createAstro($$props, $$slots);
	Astro.self = $$Navbar;
	const { user, perfil } = Astro.locals;
	const puedeVerCoach = perfil?.rol === "admin" || perfil?.rol === "editor";
	const linkClass = "text-club-white/90 transition-colors hover:text-club-blue";
	const mobileLinkClass = "block rounded-lg px-3 py-2 text-club-white/90 transition-colors hover:bg-club-blue/20 hover:text-club-blue";
	return renderTemplate`${maybeRenderHead($$result)}<nav class="mx-auto w-full max-w-4xl px-4 py-3 sm:px-6"><div class="flex items-center justify-between"><a href="/" class="text-lg font-bold text-club-white transition-colors hover:text-club-blue">Rebotia</a><div class="hidden items-center gap-x-5 text-sm font-medium sm:flex"><a href="/"${addAttribute(linkClass, "class")}>Inicio</a><a href="/partidos"${addAttribute(linkClass, "class")}>Partidos jugados</a>${puedeVerCoach && renderTemplate`<a href="/coach"${addAttribute(linkClass, "class")}>Coach</a>`}${user ? renderTemplate`${renderComponent($$result, "Fragment", Fragment, {}, { "default": ($$result) => renderTemplate`<a href="/perfil"${addAttribute(linkClass, "class")}>Perfil</a><form method="POST" action="/api/logout"><button type="submit"${addAttribute(`cursor-pointer ${linkClass}`, "class")}>Cerrar sesión</button></form>` })}` : renderTemplate`<a href="/login" class="rounded-full bg-club-blue px-4 py-1.5 font-semibold text-club-navy transition-colors hover:bg-club-white">Iniciar sesión</a>`}</div><button id="nav-toggle" type="button" aria-expanded="false" aria-controls="nav-menu" class="flex h-9 w-9 items-center justify-center rounded-lg text-club-white sm:hidden"><span class="sr-only">Abrir menú</span><svg id="nav-icon-open" xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M4 6h16M4 12h16M4 18h16"></path></svg><svg id="nav-icon-close" xmlns="http://www.w3.org/2000/svg" class="hidden h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"></path></svg></button></div><div id="nav-menu" class="hidden flex-col gap-1 pt-3 sm:hidden"><a href="/"${addAttribute(mobileLinkClass, "class")}>Inicio</a><a href="/partidos"${addAttribute(mobileLinkClass, "class")}>Partidos jugados</a>${puedeVerCoach && renderTemplate`<a href="/coach"${addAttribute(mobileLinkClass, "class")}>Coach</a>`}${user ? renderTemplate`${renderComponent($$result, "Fragment", Fragment, {}, { "default": ($$result) => renderTemplate`<a href="/perfil"${addAttribute(mobileLinkClass, "class")}>Perfil</a><form method="POST" action="/api/logout"><button type="submit"${addAttribute(`w-full cursor-pointer text-left ${mobileLinkClass}`, "class")}>Cerrar sesión</button></form>` })}` : renderTemplate`<a href="/login"${addAttribute(mobileLinkClass, "class")}>Iniciar sesión</a>`}</div></nav>${renderScript($$result, "C:/Users/USUARIO/Desktop/EloyProjects/rebotia/src/components/Navbar.astro?astro&type=script&index=0&lang.ts")}`;
}, "C:/Users/USUARIO/Desktop/EloyProjects/rebotia/src/components/Navbar.astro", void 0);
//#endregion
//#region src/layouts/Layout.astro
createAstro("https://astro.build");
var $$Layout = createComponent(($$result, $$props, $$slots) => {
	const Astro = $$result.createAstro($$props, $$slots);
	Astro.self = $$Layout;
	const { title = "Rebotia" } = Astro.props;
	return renderTemplate`<html lang="es"><head><meta charset="utf-8"><link rel="icon" type="image/svg+xml" href="/favicon.svg"><meta name="viewport" content="width=device-width"><meta name="generator"${addAttribute(Astro.generator, "content")}><title>${title}</title>${renderHead($$result)}</head><body class="flex min-h-screen flex-col bg-club-white text-club-navy"><header class="sticky top-0 z-10 bg-club-navy shadow-md">${renderComponent($$result, "Navbar", $$Navbar, {})}</header><main class="mx-auto w-full max-w-4xl flex-1 px-4 py-8 sm:px-6">${renderSlot($$result, $$slots["default"])}</main><footer class="bg-club-navy py-4 text-center text-sm text-club-white/70"><p>&copy; ${(/* @__PURE__ */ new Date()).getFullYear()} Rebotia</p></footer></body></html>`;
}, "C:/Users/USUARIO/Desktop/EloyProjects/rebotia/src/layouts/Layout.astro", void 0);
//#endregion
export { renderScript as n, $$Layout as t };
