resource "aws_instance" "jump-server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  vpc_security_group_ids       = [aws_security_group.jump-server-sg.id]
  associate_public_ip_address  = true
  availability_zone            = var.availability_zone
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name  # Attach IAM role to the EC2 instance

  tags = {
    Name = "jump-server"
  }

  root_block_device {
    volume_size = var.volume_size  # Increase root volume size to 50 GB
    volume_type = var.volume_type  # Change volume type to gp3
    tags = {
      Name = "jump-server-root-vol"
    }
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"  # Update with appropriate username based on your AMI
    private_key = file("./einfochips.pem")  # Update with the path to your private key
    host        = self.public_ip # SSH into the public IP of the instance
    port        = 22 
    timeout     = "5m"    
  }

  provisioner "file" {
    source = "./file.txt" 
    destination = "/home/ubuntu/file.txt"  
  }

  provisioner "file" {
    source = "./install_http.sh" 
    destination = "/home/ubuntu/install_http.sh"  
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/install_http.sh",  # Make the script executable
      "pwd",
      "sh install_http.sh"  # Execute the script
    ]
  }
}

resource "aws_key_pair" "einfochips" {
  key_name   = "einfochips"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/BypnJ6rfth+FW8RWmLyfYnIe+dWZkv06saDv/6AQD5yszJbsuzYBQY/rjAmnpj5ITt+Qg4pSPdA7qtzi47LPuyzXds5S5TpHXIdUD1yf+AyP4oCkK5Nt6h9IvKomhHquX6t/Uk4s5GnYaHVouDYBh6ghxKsF0jFj8wI0IG2csKQjyXjnHd5EZfalCTQQhfLzXpZ4DDrgUghoagbkUs/uM4ZUW06sPaCMTN/Mzg+lipL5bYtAd/IHBXfr3p0hJxlnAV8TjRYqAGKOeeqIfQAsVBNz5T1e/3f+YMJxKxC42T1WU7ToFG1D+Wte54FYdRAbibCKJ0mbDPvhJW5gEjlQleIpWGa0jhwdvkgOVPHl4ifL2p8of6VsgFJbw8TDOO6FZnGHLDVvR3KQi7Uoxt86g1MGq2gtkOJubAdyW92vh3fDcSI41IMmERaATysbK6FZVCShJ1BH0+GpudW9fwv1EtZIdIcqzPjp0Ua2oRJuMbCM2d5+F6g++KFS4rcnI5U= rajaram@DESKTOP-6MHBN3D"
  tags = {
    Name = "einfochips"
  }
}

resource "aws_security_group" "jump-server-sg" {
  name        = "jump-server-sg"
  description = "Security group for jump server"
  vpc_id = var.vpc_security_group_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH traffic"
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all traffic"
  }
  
  tags = {
      Name = "jump-server-sg"
  }
}

resource "aws_ebs_volume" "jump-server" {
  availability_zone = var.availability_zone
  size             = var.volume_size
  type             = var.volume_type
  tags = {
    Name = "jump-server"
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "EC2_Admin_Role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "admin_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2_Admin_Profile"
  role = aws_iam_role.ec2_role.name
}