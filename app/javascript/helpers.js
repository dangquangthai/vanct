window.removeClass = function(element, classes) {
  if (typeof element === 'string') {
    element = document.querySelector(element);
  }
  classes.split(' ').forEach(className => element?.classList.remove(className));
};

window.addClass = function(element, classes) {
  if (typeof element === 'string') {
    element = document.querySelector(element);
  }
  classes.split(' ').forEach(className => element?.classList.add(className));
};

window.toggleClass = function(element, classes) {
  if (typeof element === 'string') {
    element = document.querySelector(element);
  }
  classes.split(' ').forEach(className => element?.classList.toggle(className));
};

window.hasClass = function(element, className) {
  if (typeof element === 'string') {
    element = document.querySelector(element);
  }
  return element.classList.contains(className);
};

window.show = function(element) {
  if (typeof element === 'string') {
    element = document.querySelector(element);
  }
  removeClass(element, 'hidden');
};

window.hide = function(element) {
  if (typeof element === 'string') {
    element = document.querySelector(element);
  }
  addClass(element, 'hidden');
};

window.waitForElement = function(selector) {
  return new Promise(resolve => {
    if (document.querySelector(selector)) {
      return resolve(document.querySelector(selector))
    }

    const observer = new MutationObserver(mutations => {
      if (document.querySelector(selector)) {
        resolve(document.querySelector(selector))
        observer.disconnect()
      }
    })

    observer.observe(document.body, {
      childList: true,
      subtree: true
    })
  })
};

window.turboFetch = function(url, options = {}) {
  const { method, callback, payload } = options;

  const requestParams = {
    method: method || 'GET',
    headers: {
      Accept: "text/vnd.turbo-stream.html",
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
    },
  };

  if (payload) {
    if (typeof payload === 'string') {
      requestParams.body = payload;
    } else {
      requestParams.body = JSON.stringify(payload);
    }
  }

  fetch(url, requestParams).then(r => r.text()).then(html => {
    Turbo.renderStreamMessage(html)
    return true
  }).then(data => {
    if (callback) {
      callback(data);
    }
  });
};

window.triggerEvent = function(target, eventName, data) {
  if (typeof target === 'string') {
    target = document.querySelector(target);
  }

  if (typeof data === 'undefined') {
    target.dispatchEvent(new Event(eventName));
  } else {
    const eventData = { bubbles: true, detail: data }
    target.dispatchEvent(new CustomEvent(eventName, eventData));
  }
};

window.debounce = function(func, timeout) {
  let timer;
  return (...args) => {
    clearTimeout(timer);
    timer = setTimeout(() => { func.apply(this, args); }, timeout);
  };
}

window.lockScroll = function() {
  const scrollBarWidth = window.innerWidth - document.documentElement.clientWidth;
  document.body.style.paddingRight = `${scrollBarWidth}px`;
  document.body.style.overflow = 'hidden';
}

window.unlockScroll = function() {
  document.body.style.removeProperty('padding-right');
  document.body.style.removeProperty('overflow');
}

window.sortTable = function(table, col, reverse, header) {
  table.querySelectorAll('thead tr th').forEach(th => removeClass(th, 'sort-up sort-down'));
  if (reverse) {
    addClass(header, 'sort-up');
    removeClass(header, 'sort-down')
  } else {
    addClass(header, 'sort-down');
    removeClass(header, 'sort-up')
  }

  var tb = table.tBodies[0], // use `<tbody>` to ignore `<thead>` and `<tfoot>` rows
      tr = Array.prototype.slice.call(tb.rows, 0), // put rows into array
      i;
  reverse = -((+reverse) || -1);
  tr = tr.sort(function (a, b) { // sort rows
      return reverse // `-1 *` if want opposite order
          * (a.cells[col].textContent.trim() // using `.textContent.trim()` for test
              .localeCompare(b.cells[col].textContent.trim())
             );
  });
  for(i = 0; i < tr.length; ++i) tb.appendChild(tr[i]); // append each row in order
}

window.makeSortable = function(table) {
  var th = table.tHead, i;
  th && (th = th.rows[0]) && (th = th.cells);
  if (th) i = th.length;
  else return; // if no `<thead>` then do nothing
  while (--i >= 0) (function (i) {
    var dir = 1;
    const header = th[i];
    if (!header.classList.contains('disable-sort')) {
      header.addEventListener('click', function () {
        sortTable(table, i, (dir = 1 - dir), header);
      });
    }
  }(i));
}
