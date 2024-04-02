workspace {
    model {
        customer = person "Customer" "Um cliente"
        softwareSystem = softwareSystem "Wallet" {
            spa = container "SPA" "Digital Wallet SPA" "ReactJS" "WebBrowser" {
                customer -> this "https"
            }
            apiGateway = container "API Gateway" "Proxy all requests" "Spring Boot" {
                spa -> this "json/https"
            }
            walletCore = container "Wallet Core" "Responsible for transactions" "Spring Boot" {
                apiGateway -> this "json/https"
            }
            balancesAPI = container "Balances API" "Responsible for balance" "Spring Boot" {
                apiGateway -> this "json/https"
            }
            statementAPI = container "Statement API" "Responsible for statement" "Spring Boot" {
                apiGateway -> this "json/https"
            }
            walletCoreDatabase = container "Wallet Core Database" "Responsible for transactions" "Mysql" "Database" {
                walletCore -> this "Read and write data"
            }
            balancesAPIDatabase = container "Balances API Database" "Responsible for balance" "Mysql" "Database" {
                balancesAPI -> this "Read and write data"
            }
            statementAPIDatabase = container "Statement API Database" "Responsible for statement" "Mysql" "Database" {
                statementAPI -> this "Read and write data"
            }
            kafka = container "Kafka" "Cluster Kafka" "Kafka" "KafkaCluster" {
                walletCore -> this "Publish Messages"
                this -> statementAPI "Send messages from topic to update statement"
                this -> balancesAPI "Send messages from topic  to update balance"
            }
        }
    }
    views {
        systemContext softwareSystem {
            include *
            autolayout
        }
        container softwareSystem {
            include *
            autolayout lr
        }
        theme default
        styles {
             element "Database" {
                shape Cylinder
            }
            element "WebBrowser" {
                shape WebBrowser
            }
            element "KafkaCluster" {
                shape Pipe
            }
        }
    }
}
