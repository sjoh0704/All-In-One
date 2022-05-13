output addon_dependencies {
    value = {}
    depends_on = [
        aws_eks_addon.addons
    ]
}