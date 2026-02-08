window.addEventListener('message', function(e) {
    if (e.data.action === 'open') {
        document.body.style.display = 'block'
    }

    if (e.data.action === 'update') {
        const list = document.getElementById('list')
        list.innerHTML = ''
        for (const id in e.data.trackers) {
            list.innerHTML += `<p>Vehicle: ${e.data.trackers[id].label}</p>`
        }
    }
})

function closeUI() {
    fetch(`https://${GetParentResourceName()}/close`, { method: 'POST' })
}
