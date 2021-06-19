terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_vpc" "Main" {                # Creating VPC here
   cidr_block       = var.main_vpc_cidr     # Defining the CIDR block use 10.0.0.0/24 for demo
   instance_tenancy = "default"
  tags = {
    Name = "learning"
  }
 }
#Creating an internet getway and attaching it to VPC
 resource "aws_internet_gateway" "IGW" {    # Creating Internet Gateway
    vpc_id =  aws_vpc.Main.id               # vpc_id will be generated after we create VPC
    tags = {
    Name = "learning-internet-gateway"
  }
 }

#Create a public subnet
resource "aws_subnet" "publicsubnets" {    # Creating Public Subnets
   vpc_id =  aws_vpc.Main.id
   cidr_block = var.public_subnets        # CIDR block of public subnets
  tags = {
    Name = "learning-public"
  }
 }
resource "aws_subnet" "privatesubnets" {
   vpc_id =  aws_vpc.Main.id
   cidr_block = var.private_subnets         # CIDR block of private subnets
  tags = {
    Name = "learning-private"
  }
 }
resource "aws_route_table" "PublicRT" {    # Creating RT for Public Subnet
    vpc_id =  aws_vpc.Main.id
         route {
    cidr_block = "0.0.0.0/0"               # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.IGW.id
     }
  tags = {
    Name = "learning-public-route"
  }
 }

resource "aws_route_table" "PrivateRT" {    # Creating RT for Private Subnet
   vpc_id = aws_vpc.Main.id
   route {
   cidr_block = "0.0.0.0/0"             # Traffic from Private Subnet reaches Internet via NAT Gateway
   nat_gateway_id = aws_nat_gateway.NATgw.id
   }
   tags = {
    Name = "learning-private-route"
  }
 }
resource "aws_route_table_association" "PublicRTassociation" {
    subnet_id = aws_subnet.publicsubnets.id
    route_table_id = aws_route_table.PublicRT.id
 }
resource "aws_route_table_association" "PrivateRTassociation" {
    subnet_id = aws_subnet.privatesubnets.id
    route_table_id = aws_route_table.PrivateRT.id
 }
#creating elastic IP for NAT getway
resource "aws_eip" "nateIP" {
   vpc   = true
   tags = {
    Name = "learning-nateIP"
  }
 }

#Creating the NAT Gateway using subnet_id and allocation_id
 resource "aws_nat_gateway" "NATgw" {
   allocation_id = aws_eip.nateIP.id
   subnet_id = aws_subnet.publicsubnets.id
    tags = {
    Name = "learning-public-natgw"
  }
 }
#instances in public and private subnet




