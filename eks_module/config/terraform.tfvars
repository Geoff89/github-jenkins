
aws_eks_cluster_config = {

      "demo-cluster" = {

        eks_cluster_name         = "demo-cluster1"
        eks_subnet_ids = ["subnet-1e805541","subnet-fb36ff9d","subnet-58f62179","subnet-e6b129ab"]
        tags = {
             "Name" =  "demo-cluster"
         }  
      }
}

eks_node_group_config = {

  "node1" = {

        eks_cluster_name         = "demo-cluster"
        node_group_name          = "mynode"
        nodes_iam_role           = "eks-node-group-general1"
        node_subnet_ids          = ["subnet-1e805541","subnet-fb36ff9d","subnet-58f62179","subnet-e6b129ab"]

        tags = {
             "Name" =  "node1"
         } 
  }
}