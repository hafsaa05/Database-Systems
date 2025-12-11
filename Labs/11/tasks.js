// TASK 1: Create database and insert multiple documents
print("=== TASK 1: Creating database and inserting multiple documents ===");

use inventoryDB;

const initialFurniture = [
    {
        name: "Dining Table",
        color: "Brown",
        dimensions: [180, 90, 75], // [length, width, height] in cm
        price: 299.99,
        material: "Oak Wood",
        category: "Dining"
    },
    {
        name: "Office Chair",
        color: "Black",
        dimensions: [60, 60, 110],
        price: 149.99,
        material: "Leather",
        category: "Office"
    },
    {
        name: "Bookshelf",
        color: "White",
        dimensions: [120, 30, 180],
        price: 199.99,
        material: "Particle Board",
        category: "Storage"
    }
];

const insertManyResult = db.furniture.insertMany(initialFurniture);
print("Inserted " + insertManyResult.insertedCount + " documents");
print("Inserted IDs: " + JSON.stringify(insertManyResult.insertedIds));

// TASK 2: Insert a single document using insertOne()
print("\n=== TASK 2: Inserting single document with insertOne() ===");

const deskDocument = {
    name: "Desk",
    color: "Brown",
    dimensions: [150, 75, 72], // Standard desk dimensions
    price: 249.99,
    material: "Mahogany",
    category: "Office",
    features: ["Drawers", "Cable Management"]
};

const insertOneResult = db.furniture.insertOne(deskDocument);
print("Inserted document with ID: " + insertOneResult.insertedId);

print("\nCurrent collection contents:");
db.furniture.find().forEach(doc => {
    printjson(doc);
});

// TASK 3: Query documents where dimensions[0] > 30

print("\n=== TASK 3: Finding furniture with first dimension > 30cm ===");

const largeFurniture = db.furniture.find({
    "dimensions.0": { $gt: 30 }
});

print("Furniture with length > 30cm:");
let count1 = 0;
largeFurniture.forEach(doc => {
    count1++;
    print(count1 + ". " + doc.name + " - Dimensions: " + doc.dimensions);
});

// TASK 4: Complex query with AND/OR conditions

print("\n=== TASK 4: Complex query - Brown AND (Table OR Chair) ===");

db.furniture.insertMany([
    { name: "Coffee Table", color: "Brown", dimensions: [100, 50, 45] },
    { name: "Dining Chair", color: "Brown", dimensions: [45, 45, 95] },
    { name: "Side Table", color: "Black", dimensions: [40, 40, 60] }
]);

const complexQueryResult = db.furniture.find({
    $and: [
        { color: "Brown" },                      // Must be Brown
        { 
            $or: [                               // AND must be either Table or Chair
                { name: { $regex: /Table/i } },  // Case-insensitive regex for "Table"
                { name: { $regex: /Chair/i } }   // Case-insensitive regex for "Chair"
            ]
        }
    ]
});

print("Brown furniture that are Tables or Chairs:");
let count2 = 0;
complexQueryResult.forEach(doc => {
    count2++;
    print(count2 + ". " + doc.name + " (" + doc.color + ")");
});

// TASK 5: Update one document (single update)
print("\n=== TASK 5: Updating single document ===");

const updateOneResult = db.furniture.updateOne(
    { name: "Dining Table" },          // Filter: find document with name "Dining Table"
    { 
        $set: {                        // Update operation
            color: "Ivory",
            lastUpdated: new Date()    // Adding timestamp for audit
        }
    }
);

print("Update One Result:");
print("Matched Count: " + updateOneResult.matchedCount);
print("Modified Count: " + updateOneResult.modifiedCount);

const updatedDoc = db.furniture.findOne({ name: "Dining Table" });
print("Updated document: " + updatedDoc.name + " is now " + updatedDoc.color);

// TASK 6: Update multiple documents
print("\n=== TASK 6: Updating multiple documents ===");

const updateManyResult = db.furniture.updateMany(
    { color: "Brown" },                // Filter: all Brown furniture
    { 
        $set: { 
            color: "Dark Brown",
            updatedAt: new Date()
        }
    }
);

print("Update Many Result:");
print("Matched Count: " + updateManyResult.matchedCount + " documents found");
print("Modified Count: " + updateManyResult.modifiedCount + " documents updated");

print("\nAll Dark Brown furniture:");
db.furniture.find({ color: "Dark Brown" }).forEach(doc => {
    print("- " + doc.name);
});

// TASK 7: Delete one document
print("\n=== TASK 7: Deleting single document ===");


const deleteOneResult = db.furniture.deleteOne(
    { name: "Office Chair" }           // Filter: delete first Office Chair
);

print("Delete One Result:");
print("Deleted Count: " + deleteOneResult.deletedCount);

const remainingChairs = db.furniture.countDocuments({ name: /Chair/i });
print("Remaining chairs in collection: " + remainingChairs);

// TASK 8: Delete multiple documents
print("\n=== TASK 8: Deleting documents with exact dimensions ===");

db.furniture.insertMany([
    { name: "Small Nightstand", color: "White", dimensions: [12, 18, 50] },
    { name: "Mini Table", color: "Black", dimensions: [12, 18, 50] },
    { name: "Compact Shelf", color: "Brown", dimensions: [12, 18, 50] }
]);

const deleteManyResult = db.furniture.deleteMany(
    { dimensions: [12, 18, 50] }      // Exact array match
);

print("Delete Many Result:");
print("Deleted Count: " + deleteManyResult.deletedCount + " documents removed");

const totalCount = db.furniture.countDocuments();
print("Total documents in collection after deletion: " + totalCount);

// TASK 9: Aggregation Pipeline - Group by color

print("\n=== TASK 9: Aggregation - Group furniture by color ===");

const aggregationResult = db.furniture.aggregate([
    {
        $group: {
            _id: "$color",                    // Group by color field
            count: { $sum: 1 },               // Count items per color
            totalValue: { 
                $sum: { 
                    $ifNull: ["$price", 0]    // Sum prices, default to 0 if null
                } 
            },
            items: { $push: "$name" },        // Array of furniture names
            averagePrice: { 
                $avg: { 
                    $ifNull: ["$price", 0]    // Average price per color
                } 
            }
        }
    },
    {
        $sort: { count: -1 }                  // Sort by count descending
    },
    {
        $project: {                           // Reshape output
            color: "$_id",
            itemCount: "$count",
            totalInventoryValue: { $round: ["$totalValue", 2] },
            averageItemPrice: { $round: ["$averagePrice", 2] },
            furnitureNames: "$items",
            _id: 0                            // Exclude _id from output
        }
    }
]);

print("Furniture grouped by color:");
print("Color\t\tCount\tTotal Value\tAvg Price\tItems");
print("=".repeat(80));

aggregationResult.forEach(group => {
    print(
        group.color.padEnd(12) + "\t" +
        group.itemCount + "\t\t$" +
        group.totalInventoryValue.toFixed(2) + "\t\t$" +
        group.averageItemPrice.toFixed(2) + "\t\t" +
        group.furnitureNames.join(", ").substring(0, 30) + "..."
    );
});

// TASK 10: Text Index and Full-Text Search

print("\n=== TASK 10: Text indexing and search ===");

print("Creating text index on 'name' field...");
db.furniture.createIndex(
    { name: "text" },           // Create text index on name field
    { 
        name: "name_text_index", // Custom index name
        default_language: "english",
        weights: { name: 10 }    // Weight for relevance scoring
    }
);

const indexes = db.furniture.getIndexes();
print("Current indexes on furniture collection:");
indexes.forEach((index, i) => {
    print((i + 1) + ". " + index.name + ": " + JSON.stringify(index.key));
});

print("\nInserting documents for text search...");
db.furniture.insertMany([
    { name: "Round Coffee Table", color: "Glass", price: 120 },
    { name: "Glass End Table", color: "Transparent", price: 85 },
    { name: "Console Table with Drawers", color: "Walnut", price: 220 },
    { name: "Folding Table", color: "Plastic", price: 45 }
]);

print("\nSearching for 'table' in furniture names:");
const textSearchResults = db.furniture.find(
    { $text: { $search: "table" } },
    { 
        score: { $meta: "textScore" },  // Include relevance score
        _id: 0,                         // Exclude ID
        name: 1,                        // Include name
        color: 1,                       // Include color
        price: 1                        // Include price
    }
).sort({ score: { $meta: "textScore" } });  // Sort by relevance

print("Search Results (sorted by relevance):");
print("Name\t\t\t\tColor\t\tPrice\tRelevance Score");
print("=".repeat(70));

let resultNum = 1;
textSearchResults.forEach(doc => {
    print(
        resultNum + ". " +
        doc.name.padEnd(25) + "\t" +
        doc.color.padEnd(12) + "\t$" +
        (doc.price || "N/A") + "\t" +
        doc.score.toFixed(3)
    );
    resultNum++;
});

// Advanced text search examples
print("\nAdvanced text search examples:");
print("1. Searching for 'coffee' OR 'end':");
db.furniture.find(
    { $text: { $search: "coffee end" } },
    { name: 1, _id: 0 }
).forEach(doc => print("- " + doc.name));

print("\n2. Phrase search for 'console table':");
db.furniture.find(
    { $text: { $search: "\"console table\"" } },
    { name: 1, _id: 0 }
).forEach(doc => print("- " + doc.name));

print("\n3. Excluding 'glass' from results:");
db.furniture.find(
    { $text: { $search: "table -glass" } },
    { name: 1, _id: 0 }
).forEach(doc => print("- " + doc.name));

// FINAL COLLECTION SUMMARY

print("\n" + "=".repeat(80));
print("FINAL COLLECTION SUMMARY");
print("=".repeat(80));

const finalStats = db.furniture.aggregate([
    {
        $facet: {
            totalCount: [{ $count: "count" }],
            byCategory: [
                { $group: { _id: "$category", count: { $sum: 1 } } }
            ],
            priceStats: [
                {
                    $group: {
                        _id: null,
                        avgPrice: { $avg: "$price" },
                        maxPrice: { $max: "$price" },
                        minPrice: { $min: "$price" }
                    }
                }
            ]
        }
    }
]);

finalStats.forEach(stats => {
    print("\nTotal Documents: " + (stats.totalCount[0]?.count || 0));
    
    print("\nPrice Statistics:");
    if (stats.priceStats[0]) {
        const ps = stats.priceStats[0];
        print("  Average Price: $" + ps.avgPrice?.toFixed(2) || "N/A");
        print("  Maximum Price: $" + ps.maxPrice || "N/A");
        print("  Minimum Price: $" + ps.minPrice || "N/A");
    }
    
    print("\nDocuments by Category:");
    stats.byCategory.forEach(cat => {
        print("  " + (cat._id || "Uncategorized") + ": " + cat.count);
    });
});

print("\n" + "=".repeat(80));
print("ALL 10 TASKS COMPLETED SUCCESSFULLY");
print("=".repeat(80));
