# Wedges, oil, and vinegar

The Unbalanced Oil and Vinegar (UOV) construction has been a central framework in multivariate cryptography since its appearance in 1999.
In fact, four schemes in the second round of NISTs additional call for signatures are UOV-based.
For efficiency considerations, most of these schemes are defined over a field of characteristic 2.
This has as a side effect that the polar forms of the UOV public maps are not only symmetric, but also alternating.

In this work, we propose a new key-recovery attack on UOV over fields of characteristic 2 that exploits this alternating property.
We interpret the polar forms of the UOV public map as elements of the exterior algebra.
Moreover, we show that these forms exhibit a structure that is dependent on the secret oil space.
Using the Plücker embedding, we also express the dual of the secret oil space as an element of the exterior algebra.
Utilizing the structure of the public maps, we can formulate relations on this secret element in this algebra.
Finally, we demonstrate that the secret oil space can be recovered using sparse linear algebra techniques.

This new attack has a lower time complexity than previous methods and reduces the security of `uov-Ip`, `uov-III`, and `uov-V`, by 4, 11, and 20 bits respectively.
In addition, the attack is applicable to MAYO$_2$ and reduces its security by 28 bits.