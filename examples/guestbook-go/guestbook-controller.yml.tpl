apiVersion: v1
kind: ReplicationController
metadata:
  name: guestbook
  labels:
    app: guestbook
spec:
  replicas: 2
  selector:
    app: guestbook
  template:
    metadata:
      labels:
        app: guestbook
    spec:
      containers:
        - name: guestbook
          image: {{ USERNAME }}/guestbook:latest
          ports:
            - name: http-server
              containerPort: 3000