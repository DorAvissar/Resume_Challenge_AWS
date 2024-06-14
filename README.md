# AWS Cloud Resume Challenge
Welcome to my Cloud Resume Challenge project! ☁️
![architecture drawio](https://github.com/DorAvissar/Resume_Challenge_AWS/assets/165499842/d9348655-4297-450f-999b-27cfd7f9ae31)

Over the course of two intensive weekends, I devoted significant effort to this project. Whether you're an experienced professional or new to AWS, I hope my project inspires and assists you on your own cloud computing journey. Let's dive in together!

# This challenge is composed of 7 main parts:

1. Write your resume in HTML and formatting it with CSS
2. Setup cloudfront distribution and S3 Bucket
3. Connect the cloudfront to the external domain
4. Setting up DynamoDB and AWS Lambda
5. Setting up the Lambda and JavaScript to get viewer counter
6. setting up CI/CD for the frontend website and to run lambda Pytest 
7. Implementing infrastructure as code with Terraform

## Prerequisites
- aws account
- GitHub account
- Visual Studio Code
- A cheap domain provider (im using GoDaddy)

## Choose region: 
Before starting to work on the project in aws console, i needed to choose which region is the best for me (for best practice).
so how to choose your best region? 
1. Proximity to Users: Select a region closest to your target audience to minimize latency and improve user experience. 
I used this <a href="https://awsspeedtest.com/latency"> site</a>  to verify the latency.

2. Compliance Requirements: Ensure the chosen region complies with any legal or regulatory requirements for data sovereignty, residency, or privacy laws applicable to your application or business. (for me its not a problem)

3. Service Availability: Check the availability of AWS services you plan to use in the region. 

4. Cost Considerations: AWS pricing can vary by region, so evaluate the cost of resources and data transfer in different regions to optimize your budget.

5. Redundancy and High Availability: If high availability is critical for your application, consider deploying resources across multiple regions for redundancy and disaster recovery purposes.

<img src="https://github.com/DorAvissar/Resume_Challenge_AWS/blob/main/website/assets/latancycheck.png?raw=true">

## Front-end

## Phase-1: Building the Resume-Website
<p>So the first phase was to build a resume static website using html and css. Since I didnt want to spend too much time on desinging the resume website I used a template from the internet and altered the code depending on how I wanted it to look. Then I added all the details necessary for the resume page.</p>
<img src="https://github.com/DorAvissar/Resume_Challenge_AWS/blob/main/website/assets/mainapp.png?raw=true">
This is the result of the staic resume page.

## Phase-2: Setup CloudFront distribution and S3 Bucket
This phase focuses on deploying the static site to the cloud. 
In AWS, this can be achieved by hosting the static site files on an S3 bucket. 
The image below shows the uploaded files for the static site in the S3 bucket.
You can access the static website through the endpoint provided by AWS for this specific site. 
However, this time, the S3 bucket is configured to allow traffic only from the CDN, which we will discuss later. This ensures that all requests to the static site go through the CDN, enhancing security and performance.
<img src="https://github.com/DorAvissar/Resume_Challenge_AWS/blob/main/website/assets/s3.png?raw=true">

## Phase-3: Domain and CDN
First I bought a domain (on godaddy -<a href="https://resumedorav.online/"> resumedorav.online</a>) for this project. 

I could have used Amazon Route 53 for DNS management, but purchase a domain from GoDaddy is cheaper.
So instead, I pointed the domain I purchased to the Amazon CloudFront endpoint. 
CloudFront is a Content Delivery Network (CDN), which is a network of multiple proxy servers with the primary goal of delivering content with high availability and performance. This ensures that users across different geographical locations can access the site faster.

To help you with this , here is a step-by-step <a href="https://sodkiewiczm.medium.com/how-to-use-go-daddy-domain-in-aws-f295645ed548"> guide</a> to migrating your GoDaddy domain to AWS using S3, CloudFormation, ACM & CloudFront .
  

## Back-end
## Phase-4: Javascript-webapp
The next challenge was to create a counter to keep track of how many times the page has been viewed. This can be achieved using JavaScript. I used an event listener to trigger the index.js function whenever the DOM elements or content are reloaded. This function sends an HTTP request to an AWS Lambda function (which we will discuss in the next phase) to get the count and display it on the website. You can take a look at the code to understand how it has been done.

## Phase-5: Lambda function
Now comes the important part. I have to create a function to update the count of visitors every time the page is reloaded. This can be achieved by using an HTTP trigger for the AWS Lambda function, meaning the function will run every time the page is reloaded. So, I created a function to fetch the count from the Amazon DynamoDB (next phase) and then update the count by increasing it by one, returning it to the front end to display the count.
You can check out the code in the lambda folder on my Github.

## Phase-6: Amazon DynamoDB
To store the number of visitors in AWS, I created an Amazon DynamoDB table. DynamoDB is also serverless, so I only had to pay for the resources I used. After creating the table, I set up the necessary attributes and primary key to store and retrieve the visitor count value. DynamoDB's flexible schema allowed me to adapt quickly, although it took some time to familiarize myself with its structure since it was my first time working with it.

## Phase-7 (Terraform)

After creating the application with the necessary services, it's time to automate the entire process. To automate the provisioning of resources in AWS, we can use Terraform, an Infrastructure as Code (IaC) tool. Since I had already provisioned the resources using the AWS CLI and the AWS Management Console, I needed a way to manage those existing resources with Terraform.

To do this, I created an import.tf file to generate a state file for the existing resources in the cloud provider. This was done using the import block. After importing the resources and generating the state files, I performed operations as if I were creating the resources from scratch.

Next, I made the necessary changes to automate the provisioning process, such as storing the application setting variables. For managing variables, I stored some of them in the tfvars.tf file. For variables that are meant to be secrets, I passed them as environment variables. Yes, you can store the values of Terraform variables as environment variables; just make sure to prefix them with TF_VAR_<variable-name>. While there are many other ways to store and reference secrets, I personally chose this method for this project.

You can check out the Terraform files in the terraform folder. For guidance through this part, refer to these resources:
- <a href="https://developer.hashicorp.com/terraform/language/import">import.tf</a>
- <a href="https://developer.hashicorp.com/terraform/language/import">import block</a>.
- <a href="https://awstip.com/managing-secrets-on-terraform-71ed245a455f">env variables <variable-name></a>

## CI/CD
Once I had everything setup , it was really nice to be able to push updates via GitHub and have a Workflow automatically run. 

This GitHub Actions workflow automates the deployment and testing processes for a web application and Lambda functions. Named "Upload Website," it triggers on pushes to the main branch or manual dispatch. 
- The workflow consists of two jobs: "deploy" and "testLambda.
- "The "deploy" job uses jakejarvis/s3-sync-action to synchronize the contents of the website directory to an AWS S3 bucket located in the eu-central-1 region, ensuring files are kept private. It then initiates a CloudFront cache invalidation to ensure updated content is globally available. 
- The "testLambda" job runs on an Ubuntu environment, setting up Python, caching dependencies, installing requirements from tests/requirements.txt, and executing tests using pytest for Lambda functions. 

This CI/CD pipeline integrates seamlessly with AWS services and GitHub Actions, facilitating automated deployment and testing to maintain application reliability and efficiency.








