# MASSGRAVE UPDATER
A simple update bash script for MASSGRAVE

Replace the $path variable with your webserver MASGrave folder path.

Add crontab rule

Enjoy your autoupdate MASSGrave activator mirror

-----------------------------------------------------------------------

Crontab
```html
<div>
  <button onclick="copyToClipboard('#codeBlock')">Copy Code</button>
</div>

```bash
#!/bin/bash

0 0 * * */2 /usr/bin/sh /yourwebserverpath/update.sh

<script>
function copyToClipboard(element) {
  var copyText = document.querySelector(element);
  var textArea = document.createElement('textarea');
  textArea.value = copyText.textContent;
  document.body.appendChild(textArea);
  textArea.select();
  document.execCommand('copy');
  document.body.removeChild(textArea);
  alert('Code copied to clipboard!');
}
</script>

