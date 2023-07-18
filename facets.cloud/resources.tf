resource "aws_instance" "minikube" {
  ami           = "ami-053b0d53c279acc90"  
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.forassignment_subnet_1.id
  key_name      = "ec2-key"
  associate_public_ip_address = true

  tags = {
    Name = "minikube Master"
  }

  security_groups = [aws_security_group.forassignment_sg.id]

  connection {
    type        = "ssh"
    user        = "ubuntu"                
    private_key = file("./ec2-key.pem")
    host        = aws_instance.minikube.public_ip
  }
  provisioner "file" {
    source      = "${path.module}/yaml_files/"
    destination = "/home/ubuntu/"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt update -y",
      "sudo apt install -y docker-ce",
      "sudo systemctl start docker",
      "sudo apt-get update -y",
      "sudo apt-get install -y ca-certificates curl",
      "sudo apt-get install -y apt-transport-https",
      "curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg",
      "echo \"deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main\" | sudo tee /etc/apt/sources.list.d/kubernetes.list",
      "sudo apt-get -y update",
      "sudo apt-get install -y kubectl",
      "curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64",
      "sudo install minikube-linux-amd64 /usr/local/bin/minikube",
      "sudo apt -y install conntrack",
      "sudo minikube start --force", 
      "sudo kubectl apply -f blueappdeploy.yaml",
      "sudo kubectl apply -f greenappdeploy.yaml",
      "sudo kubectl apply -f blueappservice.yaml",
      "sudo kubectl apply -f greenappservice.yaml",
      "sudo minikube addons enable ingress",
      "sleep 60",
      "sudo kubectl apply -f blueingress.yaml",
      "sudo kubectl apply -f greeningress.yaml",
      "sleep 10",
      "for i in {1..20}; do curl -s http://$(sudo minikube ip) >> curl_output.txt; done",
    ]
  }
}








