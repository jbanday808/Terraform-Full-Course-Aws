# Day 7: Type Constraints in Terraform

## Topics Covered
- String, number, bool types
- Map, set, list, tuple, object types
- Type validation and constraints
- Complex type definitions

## Key Learning Points

### Basic Types
1. **string** - Used for plain text such as environment names (“dev”, “prod”), region names, tags, or any written value Terraform should treat as text
2. **number** - Represents any numeric value, including whole numbers (for instance counts) or decimals (for CPU or memory sizing)
3. **bool** - A true/false switch that enables simple decisions like turning features on/off or setting conditions inside your code
   
### Collection Types
1. **list(type)** - A sequence of values where the order matters (e.g., a list of availability zones Terraform should use)
2. **set(type)** - A collection of unique values where order does not matter (ideal for unique identifiers or tags you don’t want duplicated)
3. **map(type)** - A set of key-value pairs, similar to a dictionary, useful for passing flexible settings such as instance sizes per environment (prod = "t3.large", dev = "t2.micro")
4. **tuple([type1, type2, ...])** - A fixed list where each position expects a specific type, allowing mixed data types in one structured list
5. **object({key1=type1, key2=type2, ...})** - structured group of fields, useful for defining organized settings such as VPC configs, policies, or application parameters


### Common Type Patterns

1. **Environment-specific configurations** - Ensures that “dev” and “prod” receive different settings without accidental mix-ups
2. **Resource sizing based on type** - Forces CPU, memory, or storage values to follow the correct format so resources are sized properly 
3. **Tag standardization** - Keeps naming and tagging consistent by validating the format of all required tags
4. **Network configuration validation** - Ensures IPs, ports, CIDRs, and rules are correct before Terraform applies them
5. **Security policy enforcement** - Helps ensure encryption, logging, MFA, or other security controls are set properly through typed and validated inputs

## Best Practices

1. **Always specify types for variables** - This prevents accidental errors and makes your configuration predictable
2. **Use validation blocks for business rules** - Ensures users provide acceptable values (e.g., “instance size must be one of these allowed types”)  
3. **Provide meaningful error messages** - Clear guidance helps everyone understand what went wrong and how to fix it
4. **Use appropriate collection types (list vs set vs map)** - Choose the one that best represents how the data should behave (ordered, unique, or key/value-based)  
5. **Validate complex objects thoroughly** - Catch mistakes early when dealing with nested configurations like VPCs or app settings  
6. **Use type conversion functions when needed** - Helpful when values come in as one type but need to be used as another (e.g., converting strings to numbers)
7. **Document type requirements in descriptions** - Makes variables easier to understand, especially for teams or long-term maintenance  

## Next Steps
Continue to Day 8 to learn about Terraform meta-arguments such as count, for_each, and for loops, which help you create resources dynamically and reduce repetitive code.
