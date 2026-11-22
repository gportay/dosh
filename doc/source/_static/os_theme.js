// Copyright (c) 2026 Gaël PORTAY
// SPDX-License-Identifier: LGPL-2.1-or-later
//
// Follow the OS color scheme until the reader picks a theme with the
// sphinx_rtd_dark_mode switcher. Loaded before its default_*.js script.

(() => {
  const query = window.matchMedia('(prefers-color-scheme: dark)');

  const followOS = () => {
    if (localStorage.getItem('theme-explicit') !== null)
      return;

    const theme = query.matches ? 'dark' : 'light';
    localStorage.setItem('theme', theme);
    document.documentElement.setAttribute('data-theme', theme);

    if (typeof $ === 'function') {
      $('#themeSun').toggle(theme === 'dark');
      $('#themeMoon').toggle(theme !== 'dark');
    }
  };

  followOS();
  query.addEventListener('change', followOS);

  document.addEventListener('click', (event) => {
    if (event.target.closest('#themeSwitcher'))
      localStorage.setItem('theme-explicit', 'true');
  });
})();
