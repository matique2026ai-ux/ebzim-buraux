export declare class CreateMembershipDto {
    fullName: string;
    dob?: string;
    gender?: string;
    wilayaId: string;
    communeId: string;
    phone: string;
    email?: string;
    interests: string[];
    skills?: string[];
    motivation: string;
}
export declare class ReviewMembershipDto {
    status?: string;
    internalReviewNotes?: string;
}
