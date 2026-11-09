// components.js - the header and footer shown on every public page.
function header(page){const s=session();const links=[['home','Home'],['home#services','Services'],['home#news','Announcements'],['about','About us'],['home#contact','Contact']];
const sec=location.hash.replace(/^#/,'').split('#')[1];let cur=page==='home'&&sec?'home#'+sec:page;if(!links.some(l=>l[0]===cur))cur=page;
return `<div class="banner">${CONTENT.banner}</div>
<header class="top"><div class="wrap"><a class="logo" href="#home"><i>+</i>TeleCare</a>
<nav class="main" id="mainnav" aria-label="Main">${links.map(([h,t])=>`<a href="#${h}" class="${h===cur?'on':''}">${t}</a>`).join('')}</nav>
${s?`<div class="row"><a class="btn" href="#${s.role==='admin'?'admin':'home'}">${esc(s.name.split(' ')[0])}</a><button class="btn" data-act="logout">Log out</button></div>`:`<a class="btn" href="#login">Log in ↗</a>`}<button class="menu-btn" data-act="menu" aria-label="Open menu" aria-expanded="false" aria-controls="mainnav">☰</button></div></header>`}
const footer=()=>`<footer><div class="wrap"><div class="cols"><div><a class="logo" href="#home"><i style="background:#e8f1ea;color:#1a6b5a">+</i>TeleCare</a><p style="margin-top:14px;max-width:340px">${CONTENT.tagline}</p></div>
<div><h4>Explore</h4><a href="#home#services">Clinic services</a><a href="#home#news">Announcements</a><a href="#home#team">Healthcare team</a></div>
<div><h4>TeleCare</h4><a href="#about">About us</a><a href="#home#contact">Contact &amp; hours</a><a href="#login">Resident log in</a></div>
<div><h4>Good to know</h4><p>Information only. No online consultations or appointment booking.</p></div></div>
<div class="base">${CONTENT.copyright}</div></div></footer>`;