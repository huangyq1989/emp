package test;

import java.util.Stack;

/**
 * 二叉树的左右子树交换 (非递归实现)
 */
public class SwapTree {
    private static Stack<Node> stack = new Stack<>();

    public static void main(String args[]) {
        Node root = buildTree();
        inOrderVisit(root);
        swapTree(root);
        System.out.println();
        inOrderVisit(root);
    }

    public static void inOrderVisit(Node root) {
        if (root == null)
            return;
        inOrderVisit(root.left);
        System.out.print(root.data);
        inOrderVisit(root.right);
    }

    public static void swapTree(Node root) {
        if (root == null)
            return;
        Node temp = null;
        stack.push(root);
        while (!stack.isEmpty()) {
            Node node = stack.peek();

            if (node.left == null && node.right == null) {
                node.visited = true;
                stack.pop();
                continue;
            }

            if (node.left != null) {
                if (!node.left.visited) {
                    stack.push(node.left);
                }
            }

            if ((node.left == null || node.left.visited) && node.right != null) {
                if (!node.right.visited) {
                    stack.push(node.right);
                }
            }

            if ((node.left == null || node.left.visited)
                    && (node.right == null || node.right.visited)) {
                temp = node.left;
                node.left = node.right;
                node.right = temp;
                node.visited = true;
                stack.pop();
            }
        }
    }

    public static Node buildTree() {
        Node root = new Node();
        root.data = 1;

        Node temp = new Node();
        temp.data = 2;
        root.left = temp;

        temp = new Node();
        temp.data = 3;
        root.right = temp;

        temp = new Node();
        temp.data = 4;
        root.right.right = temp;

        temp = new Node();
        temp.data = 5;
        root.left.right = temp;

        temp = new Node();
        temp.data = 6;
        root.left.right.right = temp;

        return root;
    }
}

class Node {
    boolean visited = false;
    int data = 0;
    Node left = null;
    Node right = null;
}