self.addEventListener('push', function(event) {
    const data = event.data.json();
    const title = data.title || "Notification";
    const options = {
      body: data.body || "You have a new notification",
      icon: data.icon || "/icons/icon-192x192.png",
    };
    event.waitUntil(
      self.registration.showNotification(title, options)
    );
  });
  