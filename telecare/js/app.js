// app.js - router (which page shows for #home, #about, #login, #admin) and all click / form handlers.
// Loaded last, so everything else already exists.
//
// Buttons and links in the pages carry data-attributes that say what they do:
//   data-role  data-f  data-tg  data-ed  data-del  data-act   (see the click handler below)


/* ==========================================================================
   ROUTER
   The address bar decides the page:  #home  #about  #login  #admin
   "#home#services" means: show the home page, then scroll to the element with id="services".
   ========================================================================== */

const pages = { home, about, login, admin };

function route() {
  const [pageName, sectionId] = location.hash.replace(/^#/, '').split('#');
  const page = pages[pageName] ? pageName : 'home';

  app.innerHTML = pages[page]();
  document.title = 'TeleCare · ' + page[0].toUpperCase() + page.slice(1);

  const section = sectionId && document.getElementById(sectionId);
  if (section) section.scrollIntoView();
  else window.scrollTo(0, 0);
}

addEventListener('hashchange', route);


/* ==========================================================================
   SMALL HELPERS
   ========================================================================== */

// Today's date as YYYY-MM-DD (used as the "Updated" date on notices)
const todayISO = () => new Date().toISOString().slice(0, 10);

// Show an error message under the login button
function showLoginError(message) {
  $('#err').textContent = message;
}


/* ==========================================================================
   CLICKS
   One listener handles every button and link marked with a data-attribute.
   ========================================================================== */

document.addEventListener('click', e => {
  const target = e.target.closest('[data-act],[data-role],[data-f],[data-tg],[data-ed],[data-del]');
  if (!target) return;
  const d = target.dataset;

  if (d.role) return chooseRole(d.role);       // Resident / Administrator tab on the login page
  if (d.f)    return setFilter(d.f);           // All / Published / Draft tab in the admin table
  if (d.tg)   return toggleNotice(d.tg);       // Publish / Unpublish button
  if (d.del)  return deleteNotice(d.del);      // Delete button
  if (d.ed)   return openEditNotice(d.ed);     // Edit button

  switch (d.act) {
    case 'new':    return openNewNotice();
    case 'logout': return logout();
    case 'eye':    return togglePassword(target);
    case 'mode':   e.preventDefault(); return toggleSignupMode();
    case 'forgot': e.preventDefault(); return toast('Password reset is not part of this demo.');
    case 'soon':   return toast('This section is not built in the demo yet.');
    case 'menu': {
      const bar = target.closest('header.top');
      const open = bar.classList.toggle('open');
      target.setAttribute('aria-expanded', open);
      target.textContent = open ? '✕' : '☰';
      return;
    }
    case 'goann':  e.preventDefault(); return $('#ann').scrollIntoView();
  }
});

// Phone menu: close it after a link is tapped (also when the link points to the page you are already on)
document.addEventListener('click', e => {
  if (e.target.closest('nav.main a')) $('header.top')?.classList.remove('open');
});

// --- Login page ---

function chooseRole(newRole) {
  role = newRole;
  mode = 'login';
  route();
}

function toggleSignupMode() {
  mode = mode === 'login' ? 'signup' : 'login';
  route();
}

function togglePassword(button) {
  const input = $('#pw');
  input.type = input.type === 'password' ? 'text' : 'password';
  button.textContent = input.type === 'password' ? 'Show' : 'Hide';
}

function logout() {
  fetch('api/logout.php').finally(() => {
    clearSession();
    location.hash = '#home';
    loadNotices();
    toast('Logged out');
  });
}
// --- Admin dashboard: notices ---

function setFilter(status) {
  filt = status;
  route();
}

// Magpadala ng pagbabago sa database, tapos i-load ulit ang listahan
function sendNotice(data, message) {
  return fetch('api/notices.php', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data)
  })
    .then(r => r.json())
    .then(res => {
      if (!res.ok) return toast(res.error || 'Could not save. Please log in again.');
      toast(message);
      return loadNotices();
    })
    .catch(() => toast('Cannot reach the server.'));
}

function toggleNotice(id) {
  sendNotice({ action: 'toggle', id }, 'Status updated');
}

function deleteNotice(id) {
  if (!confirm('Delete this notice? This cannot be undone.')) return;
  sendNotice({ action: 'delete', id }, 'Deleted');
}

// The pop-up form (in index.html) is used for both new and edited notices.
// `editId` remembers which notice is being edited; null means "new".
function openNewNotice() {
  editId = null;
  $('#nf').reset();
  $('#dt').textContent = 'New notice';
  dlg.showModal();
}

function openEditNotice(id) {
  const notice = notices.find(n => n.id == id);
  editId = notice.id;
  $('#dt').textContent = 'Edit notice';
  $('#nt').value = notice.title;
  $('#nc').value = notice.cat;
  $('#ns').value = notice.status;
  $('#nb').value = notice.body;
  dlg.showModal();
}


/* ==========================================================================
   TYPING / TICKING
   ========================================================================== */

// Search box in the admin table: re-draw the page on every keystroke, then put the cursor back.
document.addEventListener('input', e => {
  if (e.target.id !== 'sq') return;

  q = e.target.value;                 // keep spaces as typed; admin() trims when it searches
  const cursor = e.target.selectionStart;
  route();

  const box = $('#sq');
  if (box) {
    box.focus();
    const position = Math.min(cursor, box.value.length);
    box.setSelectionRange(position, position);
  }
});

// "Before this becomes a real clinic website" checklist: remember which boxes are ticked
document.addEventListener('change', e => {
  if (e.target.dataset.ck === undefined) return;
  const ticked = load('tc_ck', []);
  ticked[e.target.dataset.ck] = e.target.checked;
  save('tc_ck', ticked);
});


/* ==========================================================================
   FORMS
   ========================================================================== */

document.addEventListener('submit', e => {
  if (e.target.id === 'lf') {
    e.preventDefault();
    return mode === 'signup' ? createResidentAccount() : logIn();
  }
  if (e.target.id === 'nf') return saveNotice();
});

function createResidentAccount() {
  const name = $('#nm').value.trim();
  const email = $('#em').value.trim().toLowerCase();
  const password = $('#pw').value;

  if (!email || !password) return showLoginError('Enter your email address and password.');
  if (!name) return showLoginError('Enter your full name.');
  if (password.length < 6) return showLoginError('Use a password with at least 6 characters.');

  fetch('api/signup.php', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ name, email, password })
  })
    .then(r => r.json())
    .then(res => {
      if (!res.ok) return showLoginError(res.error || 'Could not create the account.');
      mode = 'login';
      route();
      toast('Account created. You can log in now.');
    })
    .catch(() => showLoginError('Cannot reach the server. Is Apache running?'));
}

function logIn() {
  const email = $('#em').value.trim().toLowerCase();
  const password = $('#pw').value;

  if (!email || !password) return showLoginError('Enter your email address and password.');

  fetch('api/login.php', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password, role })
  })
    .then(r => r.json())
    .then(res => {
      if (!res.ok) return showLoginError('Email or password is incorrect. Check them and try again.');
      saveSession(res.user, $('#rm').checked);
      loadNotices();
      location.hash = res.user.role === 'admin' ? '#admin' : '#home';
      toast('Welcome, ' + res.user.name.split(' ')[0]);
    })
    .catch(() => showLoginError('Cannot reach the server. Is Apache running?'));
}

// Save button in the notice pop-up (creates a new notice, or updates the one being edited)
function saveNotice() {
  sendNotice({
    action: 'save',
    id: editId || 0,
    title: $('#nt').value.trim(),
    cat: $('#nc').value,
    status: $('#ns').value,
    body: $('#nb').value.trim()
  }, editId ? 'Changes saved' : 'Notice saved');
}


// Draw the first page when the site opens
route();