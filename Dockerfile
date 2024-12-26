FROM nginx:1.21.1
ADD https://github.com/netology-code/virtd-homeworks/raw/refs/heads/shvirtd-1/05-virt-03-docker-intro/index.html /usr/share/nginx/html/
RUN chmod +r /usr/share/nginx/html/index.html
EXPOSE 8080
ENTRYPOINT ["nginx"]
CMD ["-g","daemon off;"]
